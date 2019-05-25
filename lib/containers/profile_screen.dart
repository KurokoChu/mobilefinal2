import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobilefinal2/models/sqlite_provider.dart';
import 'package:mobilefinal2/models/current_user.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();

  UserProvider user = UserProvider();
  final userid = TextEditingController(text: CurrentUser.userId);
  final name = TextEditingController(text: CurrentUser.name);
  final age = TextEditingController(text: CurrentUser.age);
  final password = TextEditingController();
  var quote = TextEditingController(text: _data);

  static String _data = '';
  bool isUserIn = false;

  Future<void> _refresh() async {
    print('refreshing');
    readContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Setup"),
        ),
        body: Form(
          key: _formkey,
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "User Id",
                      hintText: "User Id must be between 6 to 12",
                    ),
                    controller: userid,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุข้อมูลให้ครบถ้วน";
                      } else if (isUserIn) {
                        print("hey");
                        return "This Username is taken";
                      } else if (!(6 <= value.length && value.length <= 12)) {
                        return "ต้องมีความยาวอยู่ในช่วง 6 - 12 ตัวอักษร";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุข้อมูลให้ครบถ้วน";
                      } else if (!validateName(value)) {
                        return "ต้องมีทั้ง ชื่อและนามสกุล โดยคั่นด้วย 1 space";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Age",
                    ),
                    controller: age,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "กรุณาระบุข้อมูลให้ครบถ้วน";
                      } else if (!(isNumeric(value) &&
                          10 <= int.parse(value) &&
                          int.parse(value) <= 80)) {
                        return "ต้องเป็นตัวเลขเท่านั้นและอยู่ในช่วง 10 - 80";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณาระบุข้อมูลให้ครบถ้วน';
                      }

                      if (!(value.length > 6)) {
                        return "มีความยาวมากกว่า 6";
                      }
                    }),
                RefreshIndicator(
                  child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Quote",
                      ),
                      controller: quote,
                      keyboardType: TextInputType.text,
                      maxLines: 5),
                  onRefresh: _refresh,
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                RaisedButton(
                    child: Text("SAVE"),
                    onPressed: () async {
                      await user.open("user.db");
                      Future<List<User>> allUser = user.getAllUser();
                      User userData = User();
                      userData.id = CurrentUser.id;
                      userData.userid = userid.text;
                      userData.name = name.text;
                      userData.age = age.text;
                      userData.password = password.text;
                      Future isUserTaken(User user) async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          if (user.userid == userList[i].userid &&
                              CurrentUser.id != userList[i].id) {
                            this.isUserIn = true;
                            break;
                          }
                        }
                      }

                      if (_formkey.currentState.validate()) {
                        await isUserTaken(userData);
                        if (!this.isUserIn) {
                          writeContent(quote.text);
                          await user.updateUser(userData);
                          CurrentUser.userId = userData.userid;
                          CurrentUser.name = userData.name;
                          CurrentUser.age = userData.age;
                          CurrentUser.password = userData.password;
                          Navigator.pop(context);
                        }
                      }
                      this.isUserIn = false;
                    }),
              ]),
        ));
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String data) async {
    final file = await _localFile;
    file.writeAsString('$data');
    return file;
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      setState(() {
        _data = contents;
        quote = TextEditingController(text: _data);
      });
      return contents;
    } catch (e) {
      return e;
    }
  }
}
