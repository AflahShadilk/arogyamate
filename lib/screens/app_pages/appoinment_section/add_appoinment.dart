import 'dart:io';

import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/widgets/blood_group_dropdown.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/buttons/submitbutton_addingfield.dart';

import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/date_time/date_time.dart';
import 'package:arogyamate/utilities/text_numberFields/genter_selector.dart';
import 'package:arogyamate/utilities/text_numberFields/number_field.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AppointmentSection extends StatefulWidget {
  AppointModel? appoint;
  DoctorModel? doctor;
  AppointmentSection(
      {super.key, this.appoint, this.doctor,});

 

  @override
  State<AppointmentSection> createState() => _AppointmentSectionState();
}

class _AppointmentSectionState extends State<AppointmentSection> {
  File? uploadingFile;
  final TextEditingController patientAge = TextEditingController();
  final TextEditingController patientPhone = TextEditingController();
  final TextEditingController patientDocDepart = TextEditingController();
  final TextEditingController patientDocName = TextEditingController();
  final TextEditingController patientAddress = TextEditingController();
  final TextEditingController patientName = TextEditingController();
  final BloodGroupController bloodGroup = BloodGroupController();
   final genderController = GlobalKey<FormFieldState<String>>();
  @override
  void initState() {
    super.initState();
    // Doctors are already loaded via DoctorController in main.dart
  }
  void updateFile(File? file) {
    setState(() {
      uploadingFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    



    return LayoutBuilder(
      builder: (context, constraints) {
        bool isPhone = MediaQuery.of(context).size.width < 600;
        return 
      
       Padding(
        padding: EdgeInsets.symmetric(horizontal: isPhone?6:80),
        child: Form(
            key: appoinmentForm,
            child: Column(
              children: [
                HeadLine(
                  head: 'Name',
                ),
                TextsField(hint: 'Enter Name', controller: patientName),
                SizedBox(height: 20),
                HeadLine(head: 'Genter'),
                Row(
                  children: [
                   GenderSelector(genderKey: genderController),
                  ],
                ),
                 SizedBox(height: 20),
                Row(
                  children: [
                    HeadLine(
                      head: 'Age',
                    ),
                    SizedBox(width: isPhone?s.width*0.17:s.width*0.1,),
      
                    Expanded(
                      child: HeadLine(
                        head: 'Phone',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ageField(context, isPhone, patientAge),
                    SizedBox(width: isPhone?s.width*0.02:s.width*0.02,),
      
                    Expanded(child: phoneNumberField(isPhone, patientPhone, context)),
      
                  ],
                ),
                SizedBox(height: 20),
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
                      controller: bloodGroup,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                HeadLine(head: 'Address'),
                TextsField(hint: 'Enter Address', controller: patientAddress),
                SizedBox(height: 20),
                HeadLine(head: 'Department'),
                textFieldWithBottomSheet(
                    isPhone, context, 'Eg:General', patientDocDepart,
                    onBottomSheetTap: () {
                  showBottomSheet1(context, s.width < 600, patientDocDepart);
                }),
                SizedBox(height: 20),
                HeadLine(head: "Doctor's Name"),
                textFieldWithBottomSheet(
                    isPhone, context, 'Eg:Doctors Name', patientDocName,
                    onBottomSheetTap: () {
                  showBottomSheetDoctor(context, s.width < 600, patientDocName);
                }),
              
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                        width: isPhone ? s.width * 0.4 : s.width*0.3 ,
                        child: DatePickerField(
                          controller: dateController,
                        )),
                    Spacer(),
                    SizedBox(
                        width: isPhone ? s.width * 0.4 : s.width * 0.3,
                        child:TimePickerField(
                          controller: timeController,
                        )),
                  ],
                ),
                SizedBox(height: 36),
                Column(
                  children: [
                    submit(context, isPhone, onPressAppoinment),
                    SizedBox(height: 30),
                  ],
                )
              ],
            )),
      );
      },
    );
  }

  SizedBox textFieldWithBottomSheet(bool isPhone, BuildContext context,
      String hint, TextEditingController controller,
      {Function()? onBottomSheetTap}) {
    return SizedBox(
      width: isPhone ? s.width * 0.9 : s.width * 0.96,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: onBottomSheetTap != null
                ? GestureDetector(
                    onTap: () {
                      onBottomSheetTap();
                    },
                    child: Icon(
                      Icons.add_circle_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  )
                : null,
          ),
        ),
        validator: nameValidator,
      ),
    );
  }

  Future<void> onPressAppoinment() async {
    if (appoinmentForm.currentState!.validate()) {
      final name = patientName.text.trim();
      final age = patientAge.text.trim();
      final phone = patientPhone.text.trim();
      final blood = bloodGroup.selectedBloodGroup;
      final address = patientAddress.text.trim();
      final depart = patientDocDepart.text.trim();
      final docName = patientDocName.text.trim();
      final date = dateController.text.trim();
      final time = timeController.text.trim();
      
      final gender = genderController.currentState?.value;

      // ignore: unused_local_variable
      final appointments = AppointModel(
        name: name,
        age: age,
        phone: phone,
        blood: blood,
        address: address,
        department: depart,
        doctorName: docName,
        date: date,
        time: time,
        
        title: gender,
      );
      await context.read<AppointmentController>().add(appointments);

      patientName.clear();
      patientAge.clear();
      patientPhone.clear();
      patientAddress.clear();
      patientDocDepart.clear();
      patientDocName.clear();
      bloodGroup.clear();
      dateController.clear();
      timeController.clear();

      setState(() {});
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
    }
  }
}

