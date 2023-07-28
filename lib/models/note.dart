import 'dart:io';

//Template of a note
class Note {
  final String title;
  final String content;
  final List<File> attachedImages;

  Note({
    required this.title,
    required this.content,
    this.attachedImages = const [], // Initialize with an empty list
  });
}
