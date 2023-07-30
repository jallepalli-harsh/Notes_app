import 'package:flutter/material.dart';
import 'screens/notes_list_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notes App',
      home: NotesListScreen(),
    );
  }
}
