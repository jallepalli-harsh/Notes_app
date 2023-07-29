import 'dart:io';

//Template of a note
class Note {
  int id;
  final String title;
  final String content;
  final List<File> attachedImages;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.attachedImages = const [], // Initialize with an empty list
  });

  // Convert the Note object to JSON
  Map<String, dynamic> toJson() {
    final List<String> imagePaths = attachedImages.map((image) => image.path).toList();
    return {
      'id': id,
      'title': title,
      'content': content,
      'attachedImages': imagePaths,
    };
  }

  // Create a Note object from JSON data
  factory Note.fromJson(Map<String, dynamic> json) {
    final List<File> images = (json['attachedImages'] as List<dynamic>)
        .map((imagePath) => File(imagePath))
        .toList();
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      attachedImages: images,
    );
  }
}

