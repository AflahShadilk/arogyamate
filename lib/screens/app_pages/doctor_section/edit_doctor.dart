import 'dart:io';
import 'package:arogyamate/Data_Base/functions/db_doctorfuctions.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/utilities/app_essencials/app_Bar.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/text_numberFields/number_field.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class EditDoctor extends StatefulWidget {
  DoctorModel? doctor;
  EditDoctor({super.key, this.doctor});

  @override
  State<EditDoctor> createState() => _EditDoctorState();
}

class _EditDoctorState extends State<EditDoctor>
    with SingleTickerProviderStateMixin {
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController qualification = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController experience = TextEditingController();
  final TextEditingController fees = TextEditingController();

  String? updateImage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    if (widget.doctor != null) {
      name.text = widget.doctor!.name!;
      age.text = widget.doctor!.age!;
      phone.text = widget.doctor!.phone!;
      qualification.text = widget.doctor!.qualification!;
      department.text = widget.doctor!.department!;
      experience.text = widget.doctor!.years!;
      fees.text = widget.doctor!.fees!;
      updateImage = widget.doctor!.imagePath;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool showAddIcon = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(
        context,
        "Doctor Info",
        showDeleteButton: widget.doctor != null,
        deleteFunction: widget.doctor != null
            ? () async {
                await deleteDoctor(widget.doctor!.id!);
              }
            : null,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isPhone = constraints.maxWidth < 600;
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  width: isPhone ? s.width * 0.9 : 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: doctorDetail,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue.shade700,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade200,
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundImage: updateImage != null
                                    ?kIsWeb?NetworkImage(updateImage!): FileImage(File(updateImage!))
                                    : null,
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                child: updateImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage != null) {
                                  setState(() {
                                    updateImage = pickedImage.path;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        editField(isPhone, 'Name', "Enter doctor's name", name,
                            nameValidator, TextInputType.text),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Age', "Enter age", age,
                            ageValidator, TextInputType.number),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Phone', 'Phone Number', phone,
                            phoneNumberValidator, TextInputType.number),
                        const SizedBox(height: 20),
                        editField(
                            isPhone,
                            'Qualification',
                            "Enter qualification",
                            qualification,
                            nameValidator,
                            TextInputType.text),
                        const SizedBox(height: 20),
                        editField(
                          isPhone,
                          'Department',
                          "Enter department",
                          department,
                          nameValidator,
                          TextInputType.text,
                          showAddButton: true,
                        ),
                        const SizedBox(height: 20),
                        editField(
                            isPhone,
                            'Experience',
                            "Enter Experience",
                            experience,
                            experienceValidator,
                            TextInputType.number),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Fees', "Enter Fees", fees,
                            feesValidator, TextInputType.number),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: pressMe,
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            shadowColor: Colors.blue.shade400,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
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
      }),
    );
  }

  Widget editField(
      bool isPhone,
      String heading,
      String hint,
      TextEditingController key,
      FormFieldValidator<String>? validatorr,
      TextInputType kb,
      {bool showAddButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: kb,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: key == department
                ? (department.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
                        onPressed: () {
                          department.clear();
                          setState(() {});
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          showBottomSheet1(context, s.width < 600, department);
                          setState(() {});
                        },
                        child: Icon(Icons.add_circle_outlined,
                            size: 30, color: Colors.blue),
                      ))
                : (key.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
                        onPressed: () {
                          key.clear();
                          setState(() {});
                        },
                      )
                    : null),
          ),
          validator: validatorr,
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Future<void> pressMe() async {
    if (doctorDetail.currentState!.validate()) {
      final names = name.text.trim();
      final ages = age.text.trim();
      final phones = phone.text.trim();
      final qualifications = qualification.text.trim();
      final departments = department.text.trim();
      final exprnce = experience.text.trim();
      final feeses = fees.text.trim();
      final images = updateImage;

      final updateDetails = DoctorModel(
          id: widget.doctor?.id,
          name: names,
          age: ages,
          phone: phones,
          qualification: qualifications,
          department: departments,
          years: exprnce,
          fees: feeses,
          imagePath: images);
      await updateDoctor(updateDetails);

      // Clear fields with animation
      setState(() {
        name.clear();
        age.clear();
        phone.clear();
        qualification.clear();
        department.clear();
        fees.clear();
        experience.clear();
        updateImage = null;
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }
}
