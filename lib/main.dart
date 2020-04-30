import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'Get_data.dart';

bool flag = true;
String text = '';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  void initState() {
    _read();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.0,
          ),
          TextField(
            controller: myController,
            autofocus: true,
            cursorColor: Colors.amber,
            cursorWidth: 5.0,
            decoration: InputDecoration(
              hintText: "Enter your email",
              enabled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.amber,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          FlatButton(
            onPressed: () {
              text = myController.text;
              _save();
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }

  _read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.txt');
      text = await file.readAsString();
      print(text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FetchData()),
      );
    } catch (e) {
      print('file not found');
    }
  }

  _save() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
    print('saved');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FetchData()),
    );
  }
}
