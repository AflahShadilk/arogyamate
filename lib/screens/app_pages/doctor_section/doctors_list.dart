import 'dart:io';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctors_timing.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/edit_doctor.dart';
import 'package:arogyamate/utilities/search_item/deparment_searchFilter.dart';
import 'package:arogyamate/utilities/search_item/searchbar_doctor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                'Doctors',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        // Search Bar

        Consumer<DoctorController>(
          builder: (context, ctrl, _) => Column(
            children: [
              CommonSearch(
                isPhone: true,
                hint: "Search",
                controller: searchController,
                onSearch: (value) => ctrl.search(value),
                onFilterPressed: () => ctrl.toggleSearchContainer(),
                onClearPressed: () {
                  ctrl.setShowSearchContainer(false);
                  ctrl.clearFilter();
                },
              ),
              if (ctrl.showSearchContainer)
                DoctorSearchFilter(
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
            ],
          ),
        ),

        const SizedBox(height: 20),

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
              return ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final data = filteredDoctors[index];
                  return _buildDoctorCard(context, data);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
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
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (data.imagePath?.isNotEmpty ?? false)
                        ? kIsWeb
                            ? Image.network(data.imagePath!)
                            : Image.file(File(data.imagePath!), fit: BoxFit.cover)
                        : Image.asset('assets/images/men.jpg', fit: BoxFit.cover),
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
                            data.titleName ?? '',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            data.name ?? 'Unknown Doctor',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _detailRow(context, Icons.school_outlined,
                          data.qualification ?? 'No qualification'),
                      const SizedBox(height: 4),
                      _detailRow(context, Icons.medical_services_outlined,
                          data.department ?? 'No department'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom action bar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
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
                        builder: (context) => EditDoctor(doctor: data)));
                  },
                  icon: Icon(Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.primary, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TimingDoctor(doctor: data)));
                  },
                  icon: Icon(Icons.calendar_today_outlined,
                      color: Theme.of(context).colorScheme.onPrimary, size: 16),
                  label: Text('Schedule',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
