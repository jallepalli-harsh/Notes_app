import 'package:flutter/material.dart';
import '../models/note.dart';

//Class that displays the UI of notes list in home screen.
class NoteListItem extends StatelessWidget {
  final Note note;
  final Function() onTap;
  final Function() onDelete;

  NoteListItem({required this.note, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.hashCode.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) => onDelete(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(8),
        child: ListTile(
          title: Text(note.title),
          subtitle: Text(note.content),
          onTap: onTap,
        ),
      ),
    );
  }
}
