import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '../models/note.dart';
import '../utils/image_picker_util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../widgets/bullet_list_button.dart';

//This screen pops up when you want to add a note or edit a note
class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  final bool isEditing;
  final int? index;
  

  AddEditNoteScreen({this.note, this.isEditing = false, this.index});

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  FocusNode _contentFocusNode = FocusNode();

  List<File> _attachedImages = [];
  final List<String> _attachedImagesNames = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _attachedImages = List.from(widget.note!.attachedImages);
    }
  }

@override
  void dispose() {
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }
//This is the code that describes the UI of the add/edit screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
              controller: _contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
                suffixIcon: BulletListButton(controller: _contentController),
              ),
            ),
            ),
            SizedBox(height: 16),
            _buildImageListView(), // Creates a list of images that were attached.
            ElevatedButton(
              onPressed: _attachImage,
              child: Text('Attach Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(widget.isEditing ? 'Save Changes' : 'Save Note'),
            ),
          ],
        ),
      ),
    );
  }

//Widget to create a list view of all images
  Widget _buildImageListView() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _attachedImages
                  .map((image) => _buildImageCard(image))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

//Creates a column list of all images, and adds a delete image icon at top right
  Widget _buildImageCard(File image) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _viewImage(_getImageProvider(image)),
          child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _getImageWidget(image)),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _removeImage(image),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  //Display all the images in the list
  Widget _buildImage(File image, int index) {
    return GestureDetector(
      onTap: () => _viewImage(_getImageProvider(image)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _getImageWidget(image),
          ),
          GestureDetector(
            onTap: () => _removeImage(image),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

//Chooses the right method to display the image.
  Widget _getImageWidget(File image) {
    if (kIsWeb) {
      return Image.network(image.path,
          fit: BoxFit.cover, alignment: Alignment.topLeft);
    } else if (Platform.isAndroid || Platform.isIOS) {
      return Image.file(image);
    } else {
      return Text('Image not supported on this platform');
    }
  }

  ImageProvider<Object> _getImageProvider(File image) {
    if (kIsWeb) {
      return NetworkImage(image.path);
    } else {
      return FileImage(image);
    }
  }

  Future<void> _attachImage() async {
    final source = await _showImageSourceDialog();

    if (source != null) {
      final pickedImage = await ImagePickerUtil.pickImage(source);
      if (pickedImage != null) {
        setState(() {
          _attachedImages.add(pickedImage);
          _attachedImagesNames.add('Image ${_attachedImages.length}');
        });
      }
    }
  }

  void _viewImage(ImageProvider image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(image: image),
      ),
    );
  }

  Future<ImageSource?> _showImageSourceDialog() {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: Text('Camera'),
            ),
          ],
        );
      },
    );
  }

//Deelets the image
  void _removeImage(File image) {
    setState(() {
      _attachedImages.remove(image);
    });
  }

//Saves the image
  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    //print(content);
    if (title.isEmpty || content.isEmpty) {
      return;
    }
    int time = DateTime.now().millisecondsSinceEpoch;
    final newNote = Note(
      id: time,
      title: title,
      content: content,
      attachedImages: List.from(_attachedImages),
    );

    if (widget.isEditing) {
      Navigator.pop(context, newNote);
    } else {
      Navigator.pop(context, newNote);
    }
  }
}

//UI for the viewing the images
class ImageViewScreen extends StatelessWidget {
  final ImageProvider image;

  factory ImageViewScreen({required ImageProvider image}) {
    if (image is FileImage) {
      return ImageViewScreen._(fileImage: image);
    } else if (image is NetworkImage) {
      return ImageViewScreen._(networkImage: image);
    } else {
      throw ArgumentError('Unsupported image type: ${image.runtimeType}');
    }
  }

  ImageViewScreen._({ImageProvider? fileImage, ImageProvider? networkImage})
      : image = fileImage ?? networkImage!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image(image: image),
      ),
    );
  }
}
