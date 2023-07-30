import 'dart:io';
import 'package:image_picker/image_picker.dart';

//Utility class to pick an image from gallery or camera.
class ImagePickerUtil {
  static Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return null;
    return File(pickedImage.path);
  }
}
