import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctor_details.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/add_doctor.dart';
import 'package:arogyamate/utilities/search_item/deparment_searchFilter.dart';
import 'package:arogyamate/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final TextEditingController searchController = TextEditingController();

class DoctorPage extends StatefulWidget {
  final DoctorModel? doctor;
  const DoctorPage({super.key, this.doctor});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final GlobalKey<FormState> searchin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Doctors',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.cardColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 28),
            tooltip: 'Add Doctor',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddDoctorScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: doctorsList(context),
        ),
      ),
    );
  }

  Widget doctorsList(BuildContext context) {
    bool isPhone = MediaQuery.of(context).size.width < 600;

    return Column(
      children: [
        const SizedBox(height: 12),
        // Search Bar
        Consumer<DoctorController>(
          builder: (context, ctrl, _) => Column(
            children: [
              ModernSearchBar(
                hint: "Search specialists...",
                controller: searchController,
                onSearch: (value) => ctrl.search(value),
                onFilterPressed: () => ctrl.toggleSearchContainer(),
                onClearPressed: () {
                  ctrl.setShowSearchContainer(false);
                  ctrl.clearFilter();
                },
              ),
              if (ctrl.showSearchContainer)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DoctorSearchFilter(
                    isPhone: isPhone,
                    onFiltersSelected: (department, qualification, age, fees) {
                      ctrl.setFilterSelections(
                        department: department,
                        qualification: qualification,
                        age: age,
                        fees: fees,
                      );
                      ctrl.search(searchController.text);
                    },
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Doctor List
        Expanded(
          child: Consumer<DoctorController>(
            builder: (context, ctrl, _) {
              final filteredDoctors = ctrl.doctors.where((doctor) {
                bool matchesDepartment = ctrl.selectedDepartment == null ||
                    doctor.department == ctrl.selectedDepartment;
                bool matchesQualification = ctrl.selectedQualification == null ||
                    doctor.qualification == ctrl.selectedQualification;
                bool matchesAge = ctrl.selectedAge == null ||
                    (doctor.years != null &&
                        int.tryParse(doctor.years!) == ctrl.selectedAge);
                bool matchesFees = ctrl.selectedFees == null ||
                    (doctor.fees != null &&
                        double.tryParse(doctor.fees!) == ctrl.selectedFees);
                return matchesDepartment &&
                    matchesQualification &&
                    matchesAge &&
                    matchesFees;
              }).toList();

              if (filteredDoctors.isEmpty) {
                return Center(
                  child: Text(
                    'No doctors found.',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final data = filteredDoctors[index];
                  return DoctorCard(
                    doctor: data,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DoctorView(doctor: data),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
}
