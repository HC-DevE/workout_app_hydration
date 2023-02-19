import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Journal extends StatefulWidget {
  const Journal( {super.key});

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: Center(
        child: Text('This is the journal page'),
      ),
    );
  }
}
