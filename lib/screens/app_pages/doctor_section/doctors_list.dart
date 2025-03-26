import 'dart:io';

import 'package:arogyamate/Data_Base/functions/db_doctorfuctions.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctors_timing.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/edit_doctor.dart';
import 'package:arogyamate/utilities/search_item/deparment_searchFilter.dart';
import 'package:arogyamate/utilities/search_item/searchbar_doctor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final TextEditingController searchController = TextEditingController();

// ignore: must_be_immutable
class DoctorPage extends StatefulWidget {
  DoctorModel? doctor;
  DoctorPage({super.key, this.doctor});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final GlobalKey<FormState> searchin = GlobalKey<FormState>();
  bool showSearchContainer = false;
  String? selectedDepartment;
  String? selectedQualification;
  int? selectedAge;
  double? selectedFees;

  @override
  void initState() {
    super.initState();
    fetchFilterData().then((_) {
      if (mounted) {
        setState(() {
          departments = doctorNotifier.value
              .map((d) => d.department ?? '')
              .where((d) => d.isNotEmpty)
              .toSet()
              .toList();

          qualifications = doctorNotifier.value
              .map((d) => d.qualification ?? '')
              .where((q) => q.isNotEmpty)
              .toSet()
              .toList();

          ages = doctorNotifier.value
              .map((d) => d.years != null && d.years!.isNotEmpty
                  ? int.tryParse(d.years!)
                  : null)
              .whereType<int>()
              .toSet()
              .toList();

          fees = doctorNotifier.value
              .map((d) => d.fees != null && d.fees!.isNotEmpty
                  ? double.tryParse(d.fees!)
                  : null)
              .whereType<double>()
              .toSet()
              .toList();
        });
      }
    });
  }

  List<String> departments = [];
  List<String> qualifications = [];
  List<int> ages = [];
  List<double> fees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: doctorsList(context),
          ),
        ),
      ),
    );
  }

  Widget doctorsList(BuildContext context) {
    bool isPhone = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.medical_services_rounded,
                color: Color(0xFF1A5CFF),
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                'Doctors',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Search Bar

        CommonSearch(
          isPhone: true,
          hint: "Search",
          controller: searchController,
          onSearch: (value) => searchDoctor(value),
          onFilterPressed: () {
            setState(() {
              showSearchContainer = !showSearchContainer;
            });
          },
          onClearPressed: () {
            setState(() {
              showSearchContainer = false;
              selectedDepartment = null;
              selectedAge = null;
              selectedQualification = null;
              selectedFees = null;
            });
          },
        ),

        if (showSearchContainer)
          DoctorSearchFilter(
            isPhone: isPhone,
            onFiltersSelected: (department, qualification, age, fees) {
              setState(() {
                selectedDepartment = department;
                selectedQualification = qualification;
                selectedAge = age;
                selectedFees = fees;
              });
              searchDoctor(searchController.text);
            },
          ),

        const SizedBox(height: 20),

        // Doctor List
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: doctorNotifier,
            builder: (BuildContext context, List<DoctorModel> doctorList,
                Widget? child) {
              final filteredDoctors = doctorList.where((doctor) {
                bool matchesDepartment = selectedDepartment == null ||
                    doctor.department == selectedDepartment;
                bool matchesQualification = selectedQualification == null ||
                    doctor.qualification == selectedQualification;
                bool matchesAge = selectedAge == null ||
                    (doctor.years != null &&
                        int.tryParse(doctor.years!) == selectedAge);
                bool matchesFees = selectedFees == null ||
                    (doctor.fees != null &&
                        double.tryParse(doctor.fees!) == selectedFees);

                return matchesDepartment &&
                    matchesQualification &&
                    matchesAge &&
                    matchesFees;
              }).toList();
              return ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final data = filteredDoctors[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Doctor Image
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFE1ECFF),
                                      Color(0xFFC7DBFF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: data.imagePath != null
                                      ? kIsWeb
                                          ? Image.network(data.imagePath!)
                                          : Image.file(
                                              File(data.imagePath!),
                                              fit: BoxFit.cover,
                                            )
                                      : Image.asset(
                                          'assets/images/men.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Doctor Information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data.titleName ?? 'no',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          data.name ?? 'Unknown Doctor',
                                          style: TextStyle(
                                            color: Color(0xFF1A5CFF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    _detailRow(
                                      Icons.school_outlined,
                                      data.qualification ?? 'No qualification',
                                    ),
                                    const SizedBox(height: 4),
                                    _detailRow(
                                      Icons.medical_services_outlined,
                                      data.department ?? 'No department',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => EditDoctor(
                                            doctor: data,
                                          )));
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),

                              Spacer(),
                              // Schedule
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TimingDoctor(
                                      doctor: data,
                                    ),
                                  ));
                                },
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                label: const Text(
                                  'Schedule',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A5CFF),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadowColor: Colors.blue.shade300,
                                  elevation: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Color(0xFF1A5CFF),
        ),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
