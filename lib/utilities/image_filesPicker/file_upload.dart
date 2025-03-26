import 'dart:io';
import 'package:file_picker/file_picker.dart';




class FilePickerHelper {
  static Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error picking file: $e");
    }
    return null; 
  }
}
