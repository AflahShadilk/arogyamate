// ignore_for_file: file_names, must_be_immutable, duplicate_ignore
import 'dart:io';
import 'package:arogyamate/Data_Base/functions/db_doctorfuctions.dart';

import 'package:arogyamate/data_base/models/doctor_model.dart';

import 'package:arogyamate/screens/app_pages/appoinment_section/add_appoinment.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/app_essencials/toggles.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/bottom_sheet/reusable_bottomSheet.dart';
import 'package:arogyamate/utilities/buttons/submitbutton_addingfield.dart';
import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/image_filesPicker/file_uploader.dart';
import 'package:arogyamate/utilities/text_numberFields/genter_selector.dart';
import 'package:arogyamate/utilities/text_numberFields/number_field.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

File? uploadingFile;

class AddPage extends StatefulWidget {
  DoctorModel? doctor;
  AddPage({super.key, this.doctor});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File? profileImage;

  final TextEditingController genter = TextEditingController();
  final TextEditingController docName = TextEditingController();
  final TextEditingController docAge = TextEditingController();
  final TextEditingController docPhone = TextEditingController();
  final TextEditingController docQualify = TextEditingController();
  final TextEditingController docExprnce = TextEditingController();
  final TextEditingController docDepart = TextEditingController();
  final TextEditingController docFees = TextEditingController();
  final titleController = GlobalKey<FormFieldState<String>>();
  //---------------------------------------------------------------------------------

  int _selectedShift = 0;
  void _handleToggle(int index) {
    setState(() {
      _selectedShift = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(builder: (context, Constraints) {
        bool isPhone = Constraints.maxWidth < 600;

        return SafeArea(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                _handleToggle(1);
              } else if (details.primaryVelocity! > 0) {
                _handleToggle(0);
              }
            },
            child: Container(
              height: s.height,
              width: s.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundColor, Colors.white],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isPhone ? 14 : 24, vertical: isPhone ? 12 : 24),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Toggle('Appoinment', 'Add Doctor', _selectedShift,
                            _handleToggle)
                      ],
                    ),
                    SizedBox(height: 24),
                    Expanded(
                        child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.2, 0.0),
                              end: const Offset(0.0, 0.0),
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(children: [
                          if (_selectedShift == 0) AppointmentSection(),
                          if (_selectedShift == 1)
                            DoctorDetails(isPhone, context)
                        ]),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  //----------------------------------------------------------------------------------------------------------doc details
  Padding DoctorDetails(bool isPhone, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:isPhone? 6:80),
      child: Form(
          key: docForm,
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        reusableShowBottomSheet(
                          context,
                          s.width < 600,
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.12),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: profileImage != null
                              ? kIsWeb
                                  ? NetworkImage(profileImage!.path)
                                  : FileImage(File(profileImage!.path))
                              : null,
                          child: profileImage == null
                              ? Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        // ignore: deprecated_member_use
                                        accentColor.withOpacity(0.7),
                                        primaryColor,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.photo_camera_outlined,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (profileImage == null)
                    Text(
                      "Add Photo",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              HeadLine(
                head: "Name",
              ),
              Row(
                children: [
                  TitleSelector(
                    titlekey: titleController,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextsField(
                      hint: "Enter Doctor's Name",
                      controller: docName,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  HeadLine(
                    head: 'Age',
                  ),
                  SizedBox(
                    width: isPhone ? s.width * 0.17 : s.width * 0.1,
                  ),
                  HeadLine(
                    head: 'Phone',
                  ),
                ],
              ),
              Row(
                children: [
                  ageField(context, isPhone, docAge),
                  SizedBox(width: isPhone ? s.width * 0.02 : s.width * 0.02),
                  Expanded(child: phoneNumberField(isPhone, docPhone, context)),
                ],
              ),
              SizedBox(height: 24),
              HeadLine(head: 'Qualification'),
              TextsField(
                hint: 'Enter Qualification',
                controller: docQualify,
              ),
              SizedBox(height: 24),
              HeadLine(head: 'Department'),
              Row(
                children: [
                  Expanded(child: docDepartments(isPhone, context)),
                ],
              ),
              SizedBox(height: 24),
              HeadLine(head: "Years of Experience"),
              Form(
                child: NumberField(
                  hint: 'Eg:10 Years',
                  controller: docExprnce,
                  validate: validateYearsOfExperience,
                ),
              ),
              SizedBox(height: 24),
              HeadLine(head: "Fees Structure"),
              Form(
                child: NumberField(
                  hint: 'Eg:300 per head',
                  controller: docFees,
                  validate: validateFees,
                ),
              ),
              SizedBox(height: 24),
              HeadLine(head: 'Upload Document'),
              Row(
                children: [
                  FileUploader(
                    key: UniqueKey(),
                    isPhone: isPhone,
                    onFileSelected: (File? file) {
                      if (file != null) {
                        setState(() {
                          uploadingFile = file;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  if (uploadingFile != null)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "File Uploaded",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: successColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    uploadingFile!.path.split('/').last,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      // ignore: deprecated_member_use
                                      color: textColor.withOpacity(0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color: Colors.red[400], size: 18),
                                  onPressed: () {
                                    setState(() {
                                      uploadingFile = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 36),
              Column(
                children: [
                  submit(isPhone, onPressDoc),
                  const SizedBox(height: 30),
                ],
              )
            ],
          )),
    );
  }

  //-----------------------------------------------------------------Doc Department special
  SizedBox docDepartments(bool isPhone, BuildContext context) {
    return SizedBox(
            width: isPhone ? s.width * 0.873 : s.width * 0.862,

      child: TextFormField(
        controller: docDepart,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.8,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Eg: General',
          hintStyle: TextStyle(
            color: hintColor,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                showBottomSheet1(context, s.width < 600, docDepart);
                setState(() {});
              },
              child: Icon(
                Icons.add_circle_outlined,
                color: accentColor,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPressDoc() async {
    if (profileImage != null) {
      if (docForm.currentState!.validate()) {
        final image = profileImage;
        final uploadfile = uploadingFile;
        final name = docName.text.trim();
        final age = docAge.text.trim();
        final phone = docPhone.text.trim();
        final qualification = docQualify.text.trim();
        final department = docDepart.text.trim();
        final years = docExprnce.text.trim();
        final fees = docFees.text.trim();
        final title = titleController.currentState?.value;
        final doctors = DoctorModel(
            name: name,
            age: age,
            phone: phone,
            qualification: qualification,
            department: department,
            years: years,
            fees: fees,
            imagePath: image!.path,
            newFilePath: uploadfile!.path,
            titleName: title);
        addDoctors(doctors);

        docName.clear();
        docAge.clear();
        docPhone.clear();
        docQualify.clear();
        docDepart.clear();
        docExprnce.clear();
        docFees.clear();
        setState(() {
          profileImage = null;
        });
        setState(() {});
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Photo required',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(10),
          elevation: 6,
          action: SnackBarAction(
            label: 'Add Photo',
            textColor: Colors.white,
            onPressed: () {
              reusableShowBottomSheet(
                context,
                s.width < 600,
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
          ),
        ),
      );
    }
  }
}
