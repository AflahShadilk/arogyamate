import 'dart:io';
import 'package:arogyamate/utilities/bottom_sheet/reusable_bottomSheet.dart';
import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FileUploader extends StatefulWidget {
  final bool isPhone;
  final Function(File?) onFileSelected;

  const FileUploader({
    super.key,
    required this.isPhone,
    required this.onFileSelected,
  });

  @override
  State<FileUploader> createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  File? uploadingFile; // Ensure this is correctly declared

  void updateFile(File? file) {
    setState(() {
      uploadingFile = file;
    });

    widget.onFileSelected(file);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: widget.isPhone ? screenHeight * 0.12 : screenHeight * 0.18,
      width: widget.isPhone ? screenWidth * 0.3 : screenWidth * 0.28,
      decoration: BoxDecoration(
        border: Border.all(
          // ignore: deprecated_member_use
          color: primaryColor.withOpacity(0.3),
          width: 1.5,
          style: BorderStyle.solid,
        ),
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        image: uploadingFile != null && !uploadingFile!.path.endsWith('.pdf')
            ? DecorationImage(
                image: FileImage(uploadingFile!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: uploadingFile == null
          ? IconButton(
              onPressed: () {
                reusableShowBottomSheet(
                  context,
                  screenWidth < 600,
                  isGallery: false,
                  fileIcon: Icons.upload_file_outlined,
                  photoLabel: "Take Photo",
                  fileLabel: "Upload File",
                  onPhotoSelected: (File? photo) {
                    if (photo != null) {
                      updateFile(photo);
                    }
                  },
                  onFileSelected: (File? file) {
                    if (file != null) {
                      updateFile(file);
                    }
                  },
                );
              },
              icon: Icon(
                Icons.upload_file_outlined,
                size: 36,
                color: primaryColor,
              ),
            )
          : uploadingFile!.path.endsWith('.pdf')
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.picture_as_pdf,
                        size: 42,
                        color: Color.fromARGB(255, 180, 32, 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "PDF Document",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
    );
  }
}
