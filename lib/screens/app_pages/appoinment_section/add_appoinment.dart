import 'dart:io';

import 'package:arogyamate/data_base/functions/db_appoinment.dart';
import 'package:arogyamate/data_base/functions/db_doctorfuctions.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/utilities/Field_item/field_headings.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:arogyamate/utilities/bottom_sheet/department_bottomSheet.dart';
import 'package:arogyamate/utilities/buttons/submitbutton_addingfield.dart';
import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/date_time/date_time.dart';
import 'package:arogyamate/utilities/text_numberFields/genter_selector.dart';
import 'package:arogyamate/utilities/text_numberFields/number_field.dart';
import 'package:arogyamate/utilities/text_numberFields/text_field.dart';
import 'package:flutter/material.dart';

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
    getAllDoctors();

    
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
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
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
                    submit(isPhone, onPressAppoinment),
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
          border: OutlineInputBorder(
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
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
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: onBottomSheetTap != null
                ? GestureDetector(
                    onTap: () {
                      onBottomSheetTap();
                    },
                    child: Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blue,
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
      await addAppoinment(appointments);

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

//Blood Group---------------------------------------------------------------blood group
// ignore: use_key_in_widget_constructors

class BloodGroupController extends ChangeNotifier {
  String? _selectedBloodGroup;

  String? get selectedBloodGroup => _selectedBloodGroup;

  void setBloodGroup(String? bloodGroup) {
    _selectedBloodGroup = bloodGroup;
    notifyListeners(); // Notifies listeners when value changes
  }

  void clear() {
    _selectedBloodGroup = null;
    notifyListeners();
  }
}

class BloodGroupDropdown extends StatefulWidget {
  final BloodGroupController controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const BloodGroupDropdown({
    super.key,
    required this.controller,
    this.onSaved,
    this.validator,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BloodGroupDropdownState createState() => _BloodGroupDropdownState();
}

class _BloodGroupDropdownState extends State<BloodGroupDropdown> {
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
    'None'
  ];

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: widget.controller.selectedBloodGroup,
              hint: const Text("Select "),
              items: bloodGroups.map((String bloodGroup) {
                return DropdownMenuItem<String>(
                  value: bloodGroup,
                  child: Text(bloodGroup),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  widget.controller.setBloodGroup(newValue);
                  state.didChange(newValue);
                });
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
