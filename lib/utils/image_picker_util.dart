import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return null;
    return File(pickedImage.path);
  }
}
