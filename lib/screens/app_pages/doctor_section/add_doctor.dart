// ignore_for_file: file_names, must_be_immutable, duplicate_ignore
import 'dart:io';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/controllers/doctor_form_controller.dart';
import 'package:provider/provider.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/bottom_sheet/reusable_bottomSheet.dart';
import 'package:arogyamate/utilities/buttons/submitbutton_addingfield.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/image_filesPicker/file_uploader.dart';
import 'package:arogyamate/utilities/text_numberFields/genter_selector.dart';
import 'package:arogyamate/utilities/text_numberFields/number_field.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';
import 'package:arogyamate/utilities/validators/app_validators.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class AddDoctorScreen extends StatefulWidget {
  DoctorModel? doctor;
  AddDoctorScreen({super.key, this.doctor});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {

  final TextEditingController genter = TextEditingController();
  final TextEditingController docName = TextEditingController();
  final TextEditingController docAge = TextEditingController();
  final TextEditingController docPhone = TextEditingController();
  final TextEditingController docQualify = TextEditingController();
  final TextEditingController docExprnce = TextEditingController();
  final TextEditingController docDepart = TextEditingController();
  final TextEditingController docFees = TextEditingController();
  final titleController = GlobalKey<FormFieldState<String>>();
  String? _selectedShift;
  //---------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add Doctor',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isPhone = constraints.maxWidth < 600;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isPhone ? 14 : 24, vertical: 16),
            child: DoctorDetails(isPhone, context),
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
                    child: Consumer<DoctorFormController>(
                      builder: (context, formCtrl, _) => GestureDetector(
                        onTap: () {
                          reusableShowBottomSheet(
                            context,
                            MediaQuery.of(context).size.width < 600,
                            fileIcon: Icons.upload_outlined,
                            isfile: false,
                            photoLabel: "Take Photo",
                            fileLabel: "Upload File",
                            onPhotoSelected: (File? photo) {
                              if (photo != null) {
                                formCtrl.setProfileImage(photo);
                              }
                            },
                            onFileSelected: (File? file) {
                              if (file != null) {
                                formCtrl.setProfileImage(file);
                              }
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Theme.of(context).shadowColor.withOpacity(0.12),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            backgroundImage: formCtrl.profileImage != null
                                ? kIsWeb
                                    ? NetworkImage(formCtrl.profileImage!.path)
                                    : FileImage(File(formCtrl.profileImage!.path))
                                : null,
                            child: formCtrl.profileImage == null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        size: 40,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Consumer<DoctorFormController>(
                    builder: (context, formCtrl, _) => formCtrl.profileImage == null
                        ? Text(
                            "Add Photo",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextsField(
                      hint: "Enter Doctor's Name",
                      controller: docName,
                      validator: AppValidators.validateName,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  HeadLine(
                    head: 'Age',
                  ),
                  SizedBox(
                    width: isPhone ? MediaQuery.of(context).size.width * 0.17 : MediaQuery.of(context).size.width * 0.1,
                  ),
                  HeadLine(
                    head: 'Phone',
                  ),
                ],
              ),
              Row(
                children: [
                  ageField(context, isPhone, docAge),
                  SizedBox(width: isPhone ? MediaQuery.of(context).size.width * 0.02 : MediaQuery.of(context).size.width * 0.02),
                  Expanded(child: phoneNumberField(isPhone, docPhone, context)),
                ],
              ),
              const SizedBox(height: 24),
              HeadLine(head: 'Qualification'),
              TextsField(
                hint: 'Enter Qualification',
                controller: docQualify,
                validator: (val) => AppValidators.validateRequired(val, 'Qualification'),
              ),
              const SizedBox(height: 24),
              HeadLine(head: 'Department'),
              Row(
                children: [
                  Expanded(child: docDepartments(isPhone, context)),
                ],
              ),
              const SizedBox(height: 24),
              HeadLine(head: "Years of Experience"),
              Form(
                child: NumberField(
                  hint: 'Eg:10 Years',
                  controller: docExprnce,
                  validate: AppValidators.validateExperience,
                ),
              ),
              const SizedBox(height: 24),
              HeadLine(head: "Fees Structure"),
              Form(
                child: NumberField(
                  hint: 'Eg:300 per head',
                  controller: docFees,
                  validate: AppValidators.validateFees,
                ),
              ),
              const SizedBox(height: 24),
              HeadLine(head: "Duty Shift"),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedShift,
                decoration: InputDecoration(
                  hintText: 'Select Duty Shift',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a duty shift'
                    : null,
                items: const [
                  DropdownMenuItem(value: 'Full Day', child: Text('Full Day (10:00 AM - 06:00 PM)')),
                  DropdownMenuItem(value: 'Half Day', child: Text('Half Day (12:00 PM - 06:00 PM)')),
                  DropdownMenuItem(value: 'Night Shift', child: Text('Night Shift (05:00 PM - 06:00 AM)')),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedShift = val;
                  });
                },
              ),
              const SizedBox(height: 24),
              HeadLine(head: 'Upload Document'),
              Consumer<DoctorFormController>(
                builder: (context, formCtrl, _) => Row(
                  children: [
                    FileUploader(
                      key: UniqueKey(),
                      isPhone: isPhone,
                      onFileSelected: (File? file) {
                        if (file != null) {
                          formCtrl.setUploadingFile(file);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    if (formCtrl.uploadingFile != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      formCtrl.uploadingFile!.path.split('/').last,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        // ignore: deprecated_member_use
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Theme.of(context).colorScheme.error, size: 18),
                                    onPressed: () {
                                      formCtrl.setUploadingFile(null);
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
              ),
              const SizedBox(height: 36),
              Column(
                children: [
                  submit(context, isPhone, onPressDoc),
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
            width: isPhone ? MediaQuery.of(context).size.width * 0.873 : MediaQuery.of(context).size.width * 0.862,

      child: TextFormField(
        controller: docDepart,
        validator: (val) => AppValidators.validateRequired(val, 'Department'),
        decoration: InputDecoration(
          hintText: 'Eg: General',
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                showBottomSheet1(context, MediaQuery.of(context).size.width < 600, docDepart);
              },
              child: Icon(
                Icons.add_circle_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onPressDoc() async {
    final formCtrl = context.read<DoctorFormController>();
    if (formCtrl.profileImage != null) {
      if (docForm.currentState!.validate()) {
        final name = docName.text.trim();
        final age = docAge.text.trim();
        final phone = docPhone.text.trim();
        final qualification = docQualify.text.trim();
        final department = docDepart.text.trim();
        final years = docExprnce.text.trim();
        final fees = docFees.text.trim();
        final title = titleController.currentState?.value;

        String? status;
        String? startTime;
        String? endTime;

        if (_selectedShift == 'Full Day') {
          status = Constants.fullday;
          startTime = Constants.fulldatTime[0];
          endTime = Constants.fulldatTime[1];
        } else if (_selectedShift == 'Half Day') {
          status = Constants.halfday;
          startTime = Constants.halfdayTime[0];
          endTime = Constants.halfdayTime[1];
        } else if (_selectedShift == 'Night Shift') {
          status = Constants.nightshift;
          startTime = Constants.nightshiftTime[0];
          endTime = Constants.nightshiftTime[1];
        }

        final doctors = DoctorModel(
            name: name,
            age: age,
            phone: phone,
            qualification: qualification,
            department: department,
            years: years,
            fees: fees,
            imagePath: formCtrl.profileImage!.path,
            newFilePath: formCtrl.uploadingFile?.path,
            titleName: title,
            status: status,
            startTime: startTime,
            endtime: endTime);
        await context.read<DoctorController>().add(doctors);

        docName.clear();
        docAge.clear();
        docPhone.clear();
        docQualify.clear();
        docDepart.clear();
        docExprnce.clear();
        docFees.clear();
        // ignore: use_build_context_synchronously
        context.read<DoctorFormController>().clearForm();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
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
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(10),
          elevation: 6,
          action: SnackBarAction(
            label: 'Add Photo',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: () {
              reusableShowBottomSheet(
                context,
                MediaQuery.of(context).size.width < 600,
                fileIcon: Icons.upload_outlined,
                isfile: false,
                photoLabel: "Take Photo",
                fileLabel: "Upload File",
                onPhotoSelected: (File? photo) {
                  if (photo != null) {
                    context.read<DoctorFormController>().setProfileImage(photo);
                  }
                },
                onFileSelected: (File? file) {
                  if (file != null) {
                    context.read<DoctorFormController>().setProfileImage(file);
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
