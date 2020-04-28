import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'Get_data.dart';

String _userName = '';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: CheckForSaveEmail(),
    );
  }
}

class CheckForSaveEmail extends StatefulWidget {
  @override
  _CheckForSaveEmailState createState() => _CheckForSaveEmailState();
}

class _CheckForSaveEmailState extends State<CheckForSaveEmail> {
  TextEditingController _controller;
  bool _flag = false;
  final databaseReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    _read();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _flag == false
            ? TextField(
                controller: _controller,
                onSubmitted: (String value) async {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thanks!'),
                        content: Text('You typed "$value".'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              _userName = value;
                              _save();
                              createRecord();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              ),
      ),
    );
  }

  _read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.txt');
      String text = await file.readAsString();
      print(text);
      _userName = text;
      _flag = true;
    } catch (e) {
      _flag = false;
      print("Couldn't read file");
    }
  }

  _save() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    await file.writeAsString(_userName);
    print('saved');
  }

  void createRecord() {
    var now = new DateTime.now();
    databaseReference.child(_userName).set(
      {
        "Locations": [
          {"Time-stamp": now}
        ]
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FetchData()),
          );
        },
        splashColor: Colors.blue,
        highlightColor: Colors.blue,
        child: Container(
          height: 36,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text("Tap to activate Location feeder"),
          ),
        ),
      ),
    );
  }
}
