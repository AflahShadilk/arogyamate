import 'dart:io';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/controllers/doctor_form_controller.dart';
import 'package:provider/provider.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/utilities/app_essencials/app_Bar.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/validators/app_validators.dart';
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
  String? _selectedShift;


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
      name.text = widget.doctor?.name ?? '';
      age.text = widget.doctor?.age ?? '';
      phone.text = widget.doctor?.phone ?? '';
      qualification.text = widget.doctor?.qualification ?? '';
      department.text = widget.doctor?.department ?? '';
      experience.text = widget.doctor?.years ?? '';
      fees.text = widget.doctor?.fees ?? '';

      // Pre-populate shift dropdown from existing doctor status
      final existingStatus = widget.doctor?.status;
      if (existingStatus == Constants.fullday) {
        _selectedShift = 'Full Day';
      } else if (existingStatus == Constants.halfday) {
        _selectedShift = 'Half Day';
      } else if (existingStatus == Constants.nightshift) {
        _selectedShift = 'Night Shift';
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DoctorFormController>().setUpdateImagePath(widget.doctor?.imagePath);
      });
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar(
        context,
        "Doctor Info",
        showDeleteButton: widget.doctor != null,
        deleteFunction: widget.doctor != null
            ? () async {
                await context.read<DoctorController>().delete(widget.doctor!.id!);
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
                  width: isPhone ? MediaQuery.of(context).size.width * 0.9 : 500,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
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
                        Consumer<DoctorFormController>(
                          builder: (context, formCtrl, _) => Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundImage: formCtrl.updateImagePath != null
                                      ? kIsWeb
                                          ? NetworkImage(formCtrl.updateImagePath!)
                                          : FileImage(File(formCtrl.updateImagePath!)) as ImageProvider
                                      : null,
                                  radius: 50,
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: formCtrl.updateImagePath == null
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Theme.of(context).colorScheme.primary,
                                        )
                                      : null,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final pickedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedImage != null) {
                                    formCtrl.setUpdateImagePath(pickedImage.path);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        editField(isPhone, 'Name', "Enter doctor's name", name,
                            AppValidators.validateName, TextInputType.text),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Age', "Enter age", age,
                            AppValidators.validateAge, TextInputType.number),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Phone', 'Phone Number', phone,
                            AppValidators.validatePhone, TextInputType.number),
                        const SizedBox(height: 20),
                        editField(
                            isPhone,
                            'Qualification',
                            "Enter qualification",
                            qualification,
                            (val) => AppValidators.validateRequired(val, 'Qualification'),
                            TextInputType.text),
                        const SizedBox(height: 20),
                        editField(
                          isPhone,
                          'Department',
                          "Enter department",
                          department,
                          (val) => AppValidators.validateRequired(val, 'Department'),
                          TextInputType.text,
                          showAddButton: true,
                        ),
                        const SizedBox(height: 20),
                        editField(
                            isPhone, 'Experience',
                            "Enter Experience",
                            experience,
                            AppValidators.validateExperience,
                            TextInputType.number),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Fees', "Enter Fees", fees,
                            AppValidators.validateFees, TextInputType.number),
                        const SizedBox(height: 20),
                        // ── Duty Shift Selector ──────────────────────────────
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Duty Shift',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: pressMe,
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        ListenableBuilder(
          listenable: key,
          builder: (context, _) => TextFormField(
            controller: key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: kb,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: key == department
                  ? (department.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            department.clear();
                          },
                        )
                      : GestureDetector(
                            onTap: () {
                              showBottomSheet1(context, MediaQuery.of(context).size.width < 600, department);
                            },
                          child: Icon(Icons.add_circle_outlined,
                              size: 30, color: Theme.of(context).colorScheme.primary),
                        ))
                  : (key.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            key.clear();
                          },
                        )
                      : null),
            ),
            validator: validatorr,
          ),
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
      final formCtrl = context.read<DoctorFormController>();
      final images = formCtrl.updateImagePath;

      // Map selected shift back to status and timings
      String? status = widget.doctor?.status;
      String? startTime = widget.doctor?.startTime;
      String? endTime = widget.doctor?.endtime;

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

      final updateDetails = DoctorModel(
          id: widget.doctor?.id,
          name: names,
          age: ages,
          phone: phones,
          qualification: qualifications,
          department: departments,
          years: exprnce,
          fees: feeses,
          imagePath: images,
          status: status,
          startTime: startTime,
          endtime: endTime,
          leaveDate: widget.doctor?.leaveDate,
          endLeaveDate: widget.doctor?.endLeaveDate,
          newFilePath: widget.doctor?.newFilePath,
          titleName: widget.doctor?.titleName);
      await context.read<DoctorController>().update(updateDetails);

      // Clear fields
      name.clear();
      age.clear();
      phone.clear();
      qualification.clear();
      department.clear();
      fees.clear();
      experience.clear();
      formCtrl.clearForm();

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
