import 'package:flutter/material.dart';
import 'screens/notes_list_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      home: NotesListScreen(),
    );
  }
}
