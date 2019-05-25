import 'package:flutter/material.dart';

import 'package:mobilefinal2/models/sqlite_provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  UserProvider user = UserProvider();
  final _userid = TextEditingController();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _password = TextEditingController();

  bool isUserIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              // padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 40.0),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      controller: _userid,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'User Id',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18.0),
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => print(value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณาระบุข้อมูลให้ครบถ้วน';
                        }
                        if (!(6 <= value.length && value.length <= 12)) {
                          return "มีความยาวอยู่ในช่วง 6 - 12 ตัวอักษร";
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      controller: _name,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Name',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18.0),
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.blue,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) => print(value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณาระบุข้อมูลให้ครบถ้วน';
                        }

                        if (!validateName(value)) {
                          return "ชื่อและนามสกุลโดยคั่นด้วย 1 space";
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      controller: _age,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Age',
                        hintText: 'Age',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18.0),
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => print(value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณาระบุข้อมูลให้ครบถ้วน';
                        }

                        if (!(isNumeric(value) &&
                            10 <= int.parse(value) &&
                            int.parse(value) <= 80)) {
                          return "เป็นตัวเลขเท่านั้นและอยู่ในช่วง 10 - 80";
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: TextFormField(
                      controller: _password,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 18.0),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.blue,
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onSaved: (value) => print(value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณาระบุข้อมูลให้ครบถ้วน';
                        }

                        if (!(value.length > 6)) {
                          return "มีความยาวมากกว่า 6";
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () async {
                        await user.open("user.db");
                        Future<List<User>> allUser = user.getAllUser();
                        User userData = User();
                        userData.userid = _userid.text;
                        userData.name = _name.text;
                        userData.age = _age.text;
                        userData.password = _password.text;

                        Future isNewUserIn(User user) async {
                          var userList = await allUser;
                          for (var i = 0; i < userList.length; i++) {
                            if (user.userid == userList[i].userid) {
                              this.isUserIn = true;
                              break;
                            }
                          }
                        }

                        await isNewUserIn(userData);
                        print(this.isUserIn);

                        if (_formKey.currentState.validate()) {
                          if (!this.isUserIn) {
                            _userid.text = "";
                            _name.text = "";
                            _age.text = "";
                            _password.text = "";
                            await user.insertUser(userData);
                            Navigator.pop(context);
                            print('insert complete');
                          }

                          this.isUserIn = false;

                          Future showAllUser() async {
                            var userList = await allUser;
                            for (var i = 0; i < userList.length; i++) {
                              print(userList[i]);
                            }
                          }

                          showAllUser();
                          // if (_username == 'admin') {
                          //   showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           content: Text('User นี้มีอยู่ในระบบแล้ว'),
                          //         );
                          //       });
                          // } else if (_password != _confirmpassword) {
                          //   showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           content: Text(
                          //               'Confirm password ไม่ตรงกันกับ Password'),
                          //         );
                          //       });
                          // } else {
                          //   Navigator.pushNamed(context, '/login');
                          // }
                        }
                      },
                      child: Text(
                        'REGISTER NEW ACCOUNT',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateName(String string) {
    int result = 0;
    for (int i = 0; i < string.length; ++i) {
      if (string[i] == ' ') {
        result += 1;
      }
    }

    if (result != 1) {
      return false;
    }

    var split = string.split(' ');
    if (split.length != 2) {
      return false;
    }

    if (split[0] == '' || split[1] == '') {
      return false;
    }
    return true;
  }

  bool isNumeric(String string) {
    if (string == null) {
      return false;
    }
    return double.parse(string, (e) => null) != null;
  }
}
