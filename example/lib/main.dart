// main.dart

import 'package:flutter/material.dart';
import 'package:get_suggestions/get_suggestions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Suggestions Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Suggestions Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        //THIS IS THE WIDGET YOU NEED TO USE, THIS TEXTFIELD IS FULLY CUSTOMIZABLE LIKE A NORMAL TEXTFIELD
        child: TextFieldWithSuggestions(
          textFieldController: _textEditingController,
          style: TextStyle(fontSize: 18),
          hintstyling: TextStyle(fontSize: 18, color: Colors.grey),
          maxLines: null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
    );
  }
}
