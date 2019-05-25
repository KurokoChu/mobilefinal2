import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:mobilefinal2/models/sqlite_provider.dart';
import 'package:mobilefinal2/models/current_user.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _userid = TextEditingController();
  final _password = TextEditingController();
  bool isValid = false;
  int formState = 0;

  SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            Image.network(
              "http://www.pngmart.com/files/8/Key-PNG-Transparent-1.png",
              width: 150,
              height: 150,
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User Id",
                  icon: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                controller: _userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                ),
                controller: _password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.formState += 1;
                  }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                UserProvider user = UserProvider();
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    if (userid == userList[i].userid &&
                        password == userList[i].password) {
                      CurrentUser.id = userList[i].id;
                      CurrentUser.userId = userList[i].userid;
                      CurrentUser.name = userList[i].name;
                      CurrentUser.age = userList[i].age;
                      CurrentUser.password = userList[i].password;
                      this.isValid = true;
                      sharedPreferences = await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          "username", userList[i].userid);
                      sharedPreferences.setString(
                          "password", userList[i].password);
                      break;
                    }
                  }
                }

                if (this.formState != 2) {
                  Toast.show("กรุณาระบุข้อมูลให้ครบถ้วน", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.formState = 0;
                } else {
                  this.formState = 0;
                  await isUserValid(_userid.text, _password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    _userid.text = "";
                    _password.text = "";
                  }
                }
              },
            ),
            FlatButton(
              child: Container(
                child: Text("Register New Account"),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 170.0),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> _readContent() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return e;
    }
  }
}
