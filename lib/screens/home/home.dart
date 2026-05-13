// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math' as math;
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/controllers/session_controller.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/analytics/analytics_screen.dart';
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
      body: LayoutBuilder(builder: (context, constraints) {
        bool isPhone = constraints.maxWidth < 600;
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
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // --- Header & Banner (Scrollable) ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isPhone ? 16 : 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildHeaderSection(context),
                          const SizedBox(height: 25),
                          _buildBannerSection(context, isPhone),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),

                  // --- Sticky Search & Toggle ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: isPhone ? 160 : 170,
                      maxHeight: isPhone ? 160 : 170,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: isPhone ? 16 : 24, vertical: 10),
                        child: Consumer<DoctorController>(
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
                              const SizedBox(height: 15),
                              AppToggle(
                                firstOne: 'Day Shift',
                                secondOne: 'Night Shift',
                                selectedIndex: ctrl.selectedShift,
                                onToggle: _handleToggle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- Filter Overlays & List Header ---
                  SliverToBoxAdapter(
                    child: Consumer<DoctorController>(
                      builder: (context, ctrl, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ctrl.showSearchContainer)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: isPhone ? 16 : 24, vertical: 10),
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: isPhone ? 20 : 28, vertical: 10),
                            child: Text(
                              "Available Doctors",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Doctor List ---
                  Consumer<DoctorController>(
                    builder: (context, ctrl, _) {
                      final filteredDoctors = ctrl.selectedShift == 0
                          ? _getDayShiftDoctors(ctrl.doctors, ctrl)
                          : _getNightShiftDoctors(ctrl.doctors, ctrl);

                      if (filteredDoctors.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No doctors available for this shift.',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: isPhone ? 12 : 20, vertical: 5),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => customCard(context, filteredDoctors[index]),
                            childCount: filteredDoctors.length,
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerSection(BuildContext context, bool isPhone) {
    return Consumer<SessionController>(
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
    );
  }
    



  List<DoctorModel> _getDayShiftDoctors(List<DoctorModel> doctors, DoctorController ctrl) {
    return doctors.where((data) {
      bool matchDepartment = ctrl.selectedDepartment == null || data.department == ctrl.selectedDepartment;
      bool matchQualification = ctrl.selectedQualification == null || data.qualification == ctrl.selectedQualification;
      bool matchShift = data.status == Constants.fullday || data.status == Constants.halfday;
      return matchDepartment && matchQualification && matchShift;
    }).toList();
  }

  List<DoctorModel> _getNightShiftDoctors(List<DoctorModel> doctors, DoctorController ctrl) {
    return doctors.where((data) {
      bool matchDepartment = ctrl.selectedDepartment == null || data.department == ctrl.selectedDepartment;
      bool matchQualification = ctrl.selectedQualification == null || data.qualification == ctrl.selectedQualification;
      bool matchShift = data.status == Constants.nightshift;
      return matchDepartment && matchQualification && matchShift;
    }).toList();
  }

  Widget customCard(BuildContext context, DoctorModel data) {
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
                      Expanded(
                        child: Text(
                          data.department!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
