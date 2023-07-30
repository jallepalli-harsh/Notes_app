import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/note_list_item.dart';
import 'add_edit_note_screen.dart';

//Displays the list of all notes in home screen.
class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> _notes = [];

  void _addNote(Note note) {
    setState(() {
      _notes.add(note);
    });
  }

  void _editNote(int index, Note note) {
    setState(() {
      _notes[index] = note;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }


//Open the add notes screen.
  void _openAddNoteScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditNoteScreen()),
    );

    if (result != null && result is Note) {
      _addNote(result);
    }
  }

//Opens the edit note screen.
  void _openEditNoteScreen(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditNoteScreen(
          note: _notes[index],
          isEditing: true,
          index: index,
        ),
      ),
    );

    if (result != null && result is Note) {
      _editNote(index, result);
    }
  }

//Interface for the homes screen of notes app.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return NoteListItem(
            note: note,
            onTap: () => _openEditNoteScreen(index),
            onDelete: () => _deleteNote(index), // Pass the onDelete function
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddNoteScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
