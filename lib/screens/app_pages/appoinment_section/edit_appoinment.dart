import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';

import 'package:arogyamate/widgets/blood_group_dropdown.dart';
import 'package:arogyamate/utilities/app_essencials/app_Bar.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/date_time/date_time.dart';
import 'package:arogyamate/utilities/validators/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditAppoinment extends StatefulWidget {
 AppointModel?appoint;
  EditAppoinment({super.key, this.appoint});

  @override
  // ignore: no_logic_in_create_state
  State<EditAppoinment> createState() => _EditAppointment();
}

class _EditAppointment extends State<EditAppoinment>
    with SingleTickerProviderStateMixin {
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController phone = TextEditingController();
    final BloodGroupController bloodGroups = BloodGroupController();
  final TextEditingController address = TextEditingController();
  final TextEditingController department = TextEditingController();
  final TextEditingController doctor = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();
 
  
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

    if (widget.appoint != null) {
      name.text = widget.appoint!.name!;
      age.text = widget.appoint!.age!;
      phone.text = widget.appoint!.phone!;
     bloodGroups.setBloodGroup(widget.appoint!.blood ?? 'None');

      address.text = widget.appoint!.address!;
      department.text = widget.appoint!.department!;
      doctor.text = widget.appoint!.doctorName!;
      date.text = widget.appoint!.date!;
      time.text = widget.appoint!.time!;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBar(context, "Patient Info",
          showDeleteButton:  widget.appoint != null, ),
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
                    key: patientDetail,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       
                        const SizedBox(height: 30),
                        editField(isPhone, 'Name', "Enter Patient's name", name,
                            AppValidators.validateName, TextInputType.text),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Age', "Enter age", age,
                            AppValidators.validateAge, TextInputType.number),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Phone', 'Phone Number', phone,
                            AppValidators.validatePhone, TextInputType.number),
                            const SizedBox(height: 20),
                            Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Blood :',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 13),
                  BloodGroupDropdown(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a blood group'
                        : null,
                    controller: bloodGroups,
                  ),
                ],
              ),
                        const SizedBox(height: 20),
                        editField(
                            isPhone,
                            'Address',
                            "Enter Address",
                            address,
                            (val) => AppValidators.validateRequired(val, 'Address'),
                            TextInputType.text),
                        const SizedBox(height: 20),
                        editField(isPhone, 'Department', "Enter department",
                            department, (val) => AppValidators.validateRequired(val, 'Department'), TextInputType.text),
                        const SizedBox(height: 20),
                        editField(
                            isPhone,
                            "Doctor's Name",
                            "Enter Name",
                            doctor,
                            AppValidators.validateName,
                            TextInputType.text),
                        const SizedBox(height: 20),
                        DatePickerField(controller: date),
                        const SizedBox(height: 20),
                        TimePickerField(controller: time),
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
          letterSpacing: 0.3,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: kb,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: key.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    key.clear();
                    setState(() {});
                  },
                )
              : GestureDetector(
                  onTap: () {
                    if (key == department) {
                      showBottomSheet1(context, MediaQuery.of(context).size.width < 600, department);
                    } else if (key == doctor) {
                      showBottomSheetDoctor(context, s.width < 600,doctor );
                    }
                    setState(() {});
                  },
                  child: Icon(Icons.add_circle_outlined, size: 30, color: Theme.of(context).colorScheme.primary),
                ),
        ),
        validator: validatorr,
        onChanged: (value) => setState(() {}),
      ),
    ],
  );
}


  Future<void> pressMe() async {
    if (patientDetail.currentState!.validate()) {
      final names = name.text.trim();
      final ages = age.text.trim();
      final phones = phone.text.trim();
      final bloodGroup = bloodGroups.selectedBloodGroup ?? 'None';

      final addresss = address.text.trim();
      final departments = department.text.trim();
      final doctors = doctor.text.trim();
      final dates = date.text.trim();
      final times = time.text.trim();

      final updateDetails = AppointModel(name: names, age: ages, phone: phones, blood: bloodGroup, address: addresss, department: departments, doctorName: doctors, date: dates, time: times);
     await context.read<AppointmentController>().add(updateDetails);
      // Clear fields with animation
      setState(() {
        name.clear();
        age.clear();
        phone.clear();
         bloodGroups.setBloodGroup('None'); 
        address.clear();
        department.clear();
        doctor.clear();
        date.clear();
        time.clear();
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
