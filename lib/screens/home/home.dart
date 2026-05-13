import 'dart:io';
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/controllers/session_controller.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctor_details.dart';
import 'package:arogyamate/utilities/app_essencials/toggles.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/search_item/deparment_searchFilter.dart';
import 'package:arogyamate/utilities/search_item/searchbar_doctor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  DoctorModel? doctor;
  HomePage({super.key, this.doctor});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void _handleToggle(int index) {
    context.read<DoctorController>().setFilterSelections(shift: index);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, Constraints) {
        bool isPhone = Constraints.maxWidth < 600;
        Size s = MediaQuery.of(context).size;
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
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isPhone ? 16 : 24, vertical: isPhone ? 10 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back,",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Consumer<SessionController>(
                              builder: (context, session, _) => Text(
                                session.hospitalName ?? "ArogyaMate",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // --- Banner Section ---
                    Consumer<SessionController>(
                      builder: (context, session, _) => Container(
                        height: isPhone ? 180 : 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Background Image/Illustration
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: (session.profileImage != null && session.profileImage!.isNotEmpty)
                                    ? (kIsWeb
                                        ? Image.network(session.profileImage!, fit: BoxFit.cover)
                                        : Image.file(File(session.profileImage!), fit: BoxFit.cover))
                                    : Image.network(
                                        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=2053&auto=format&fit=crop',
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            child: const Center(child: CircularProgressIndicator()),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          'assets/images/hospital.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            // Gradient Overlay for text readability
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Managing Healthcare\nWith Excellence",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Efficiency in Every Detail",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- Search & Filter Section ---
                    Consumer<DoctorController>(
                      builder: (context, ctrl, _) => Column(
                        children: [
                          CommonSearch(
                            isPhone: isPhone,
                            hint: 'Search specialists...',
                            controller: search,
                            onFilterPressed: () => ctrl.toggleSearchContainer(),
                            onClearPressed: () {
                              ctrl.setShowSearchContainer(false);
                              ctrl.clearFilter();
                            },
                            onSearch: (val) => ctrl.search(val),
                          ),
                          if (ctrl.showSearchContainer)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: DoctorSearchFilter(
                                isPhone: isPhone,
                                showAgefilter: false,
                                showFeesfilter: false,
                                onFiltersSelected: (department, qualification, age, fees) {
                                  ctrl.setFilterSelections(
                                    department: department,
                                    qualification: qualification,
                                  );
                                  ctrl.search(search.text);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Toggle Section ---
                    Consumer<DoctorController>(
                      builder: (context, ctrl, _) => AppToggle(
                        firstOne: 'Day Shift',
                        secondOne: 'Night Shift',
                        selectedIndex: ctrl.selectedShift,
                        onToggle: _handleToggle,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- List Header ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "Available Doctors",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- Doctor List ---
                    Expanded(
                      child: Consumer<DoctorController>(
                        builder: (context, ctrl, _) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: ctrl.selectedShift == 0
                                ? _doctorCardList(_dayShiftCards(ctrl.doctors, ctrl))
                                : _doctorCardList(_nightShiftCards(ctrl.doctors, ctrl)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _doctorCardList(List<Widget> cards) {
    if (cards.isEmpty) {
      return Center(
        child: Text(
          'No doctors available for this shift.',
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }

  List<Widget> _dayShiftCards(List<DoctorModel> doctors, DoctorController ctrl) {
    return doctors
        .where((data) {
          bool matchDepartment = ctrl.selectedDepartment == null ||
              data.department == ctrl.selectedDepartment;
          bool matchQualification = ctrl.selectedQualification == null ||
              data.qualification == ctrl.selectedQualification;
          bool matchShift = data.status == Constants.fullday ||
              data.status == Constants.halfday;
          return matchDepartment && matchQualification && matchShift;
        })
        .map((data) => customCard(data))
        .toList();
  }

  List<Widget> _nightShiftCards(List<DoctorModel> doctors, DoctorController ctrl) {
    return doctors
        .where((data) {
          bool matchDepartment = ctrl.selectedDepartment == null ||
              data.department == ctrl.selectedDepartment;
          bool matchQualification = ctrl.selectedQualification == null ||
              data.qualification == ctrl.selectedQualification;
          bool matchShift = data.status == Constants.nightshift;
          return matchDepartment && matchQualification && matchShift;
        })
        .map((data) => customCard(data))
        .toList();
  }

  Widget customCard(DoctorModel data) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DoctorView(doctor: data),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                backgroundImage: (data.imagePath != null && data.imagePath!.isNotEmpty)
                    ? (kIsWeb
                        ? NetworkImage(data.imagePath!) as ImageProvider
                        : FileImage(File(data.imagePath!)))
                    : null,
                child: (data.imagePath == null || data.imagePath!.isEmpty)
                    ? Icon(Icons.person_rounded, size: 30, color: Theme.of(context).colorScheme.primary)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.medical_services_outlined, size: 14, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        data.department!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${data.startTime ?? 'N/A'} - ${data.endtime ?? ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
