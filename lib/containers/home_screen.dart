import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobilefinal2/models/current_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  static String _data = '';
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      setState(() {
        _data = contents;
      });
      return _data;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }

  Future<void> _refresh() async {
    print('refreshing');
    readContent();
  }

  @override
  void initState() {
    super.initState();
    print("TEST");
    setState(() {
      print("TEST");
      readContent();
    });
  }

  // @override
  // void setState(fn) {
  //   super.setState(fn);
  //   readContent();
  // }

  @override
  Widget build(BuildContext context) {
    readContent();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            RefreshIndicator(
              child: ListTile(
                title: Text('Hello ${CurrentUser.name}'),
                subtitle: Text('this is my quote "${_data}"'),
              ),
              onRefresh: _refresh,
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                clearSharedPreferences() async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setString('username', '');
                  sharedPreferences.setString('password', '');
                }

                clearSharedPreferences();

                CurrentUser.userId = null;
                CurrentUser.name = null;
                CurrentUser.age = null;
                CurrentUser.password = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
