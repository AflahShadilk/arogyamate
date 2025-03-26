import 'dart:io';
import 'package:arogyamate/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/reusable_bottomSheet.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  File? profileImage;
  final GlobalKey<FormState> entrykey = GlobalKey<FormState>();
  final TextEditingController entryName = TextEditingController();
  final TextEditingController entryId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA), // Clean background color
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome text sections
                    Text(
                      'Welcome to',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: isMobile ? 18 : 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arogya Mate',
                      style: GoogleFonts.oleoScript(
                        color: const Color(0xFF37474F),
                        fontSize: isMobile ? 36 : 46,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 30 : 40),
                    
                    // Profile Image Selection - kept but simplified
                    GestureDetector(
                      onTap: () {
                        reusableShowBottomSheet(
                          context,
                          isMobile,
                          fileIcon: Icons.upload_outlined,
                          isfile: false,
                          photoLabel: "Take Photo",
                          fileLabel: "Upload File",
                          onPhotoSelected: (File? photo) {
                            if (photo != null) {
                              setState(() {
                                profileImage = photo;
                              });
                            }
                          },
                          onFileSelected: (File? file) {
                            if (file != null) {
                              setState(() {
                                profileImage = file;
                              });
                            }
                          },
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          shape: BoxShape.circle,
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF37474F).withOpacity(0.2),
                            width: 2,
                          ),
                          image: profileImage != null
                              ? DecorationImage(
                                  image:kIsWeb?NetworkImage(profileImage!.path): FileImage(File(profileImage!.path)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: profileImage == null
                            ? const Icon(
                                Icons.camera_alt_rounded,
                                size: 40,
                                color: Color(0xFF37474F),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Form Container
                    Container(
                      width: isMobile ? size.width * 0.9 : size.width * 0.55,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Form(
                        key: entrykey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeadLine(head: 'Hospital Name'),
                            const SizedBox(height: 10),
                            TextsField(
                                hint: 'Hospital Name', controller: entryName),
                            const SizedBox(height: 24),
                            HeadLine(head: 'Hospital ID'),
                            const SizedBox(height: 10),
                            TextsField(
                                hint: 'Enter Hospital ID', controller: entryId),
                            const SizedBox(height: 36),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: isMobile ? 50 : 56,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    OnPress();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF37474F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    // ignore: deprecated_member_use
                                    shadowColor: const Color(0xFF37474F).withOpacity(0.4),
                                  ),
                                  child: Text(
                                    "Get Started",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: isMobile ? 16 : 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> OnPress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // ignore: unnecessary_null_comparison
    if (profileImage != null && entryName.text.isNotEmpty && entryId.text.isNotEmpty) {
      prefs.setString('image', profileImage!.path);
      prefs.setString('name', entryName.text);
      prefs.setString('id', entryId.text);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      await prefs.setBool(saveKey, true);
    }
  }
}