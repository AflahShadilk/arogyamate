import 'dart:io';
import 'package:arogyamate/core/session/session_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/reusable_bottomSheet.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';

 
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
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
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
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: isMobile ? 18 : 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Arogya Mate',
                      style: GoogleFonts.oleoScript(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isMobile ? 36 : 46,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).shadowColor,
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
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                            ? Icon(
                                Icons.camera_alt_rounded,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
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
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).shadowColor.withOpacity(0.1),
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
                                    elevation: 4,
                                  ),
                                  child: Text(
                                    "Get Started",
                                    style: GoogleFonts.poppins(
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
    if (profileImage != null &&
        entryName.text.isNotEmpty &&
        entryId.text.isNotEmpty) {
      await SessionManager.saveLogin(
        image: profileImage!.path,
        name: entryName.text,
        id: entryId.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }
}