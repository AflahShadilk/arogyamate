
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// final GalleryImage1 fetchImage= GalleryImage1();
final CameraHelper fetchCamera=CameraHelper();


class GalleryImage1 {
    // ignore: unused_field
  XFile? image;
  final ImagePicker ipicker = ImagePicker();

  Future<XFile?> getImage(BuildContext context) async {
    final pickedImage = await ipicker.pickImage(source: ImageSource.gallery);
    return pickedImage;

    
  }
     
}
class CameraHelper {
  XFile? pickedFile;
  Future<File?> openCamera() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}