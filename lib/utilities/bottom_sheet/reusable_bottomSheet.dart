import 'dart:io';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/image_filesPicker/file_upload.dart';
import 'package:arogyamate/utilities/image_filesPicker/image_fetch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void reusableShowBottomSheet(
  BuildContext context,
  bool isPhone, {
  bool isfile = true,
  bool isGallery = true,
  required IconData fileIcon,
  String photoLabel = "Take Photo",
  String fileLabel = "Upload File",
  Function(File?)? onPhotoSelected,
  Function(File?)? onFileSelected,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          width: isPhone ? s.width * 0.95 : s.width * 0.95,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Choose an Option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      File? image = await fetchCamera.openCamera();
                      if (onPhotoSelected != null && image != null) {
                        onPhotoSelected(image);
                      }
                    },
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 10),
                        Text(photoLabel),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  isfile == true
                      ? GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            File? selectedFile =
                                await FilePickerHelper.pickFile();
                            if (onFileSelected != null &&
                                selectedFile != null) {
                              onFileSelected(
                                  selectedFile); 
                            }
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green,
                                child: Icon(fileIcon,
                                    color: Colors.white, size: 30),
                              ),
                              const SizedBox(height: 10),
                              Text(fileLabel),
                            ],
                          ),
                        )
                      : SizedBox(),
                  isGallery == true
                      ? GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            XFile? selectedFile =
                                await GalleryImage1().getImage(context);
                            if (onFileSelected != null &&
                                selectedFile != null) {
                              onFileSelected(File(selectedFile
                                  .path));
                            }
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.green,
                                child: Icon(fileIcon,
                                    color: Colors.white, size: 30),
                              ),
                              const SizedBox(height: 10),
                              Text('Gallery'),
                            ],
                          ),
                        )
                      : SizedBox()
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
