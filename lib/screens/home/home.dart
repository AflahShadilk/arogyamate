import 'dart:math' as math;
import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/data_base/models/doctor_model.dart';
import 'package:arogyamate/screens/app_pages/analytics/analytics_screen.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctor_details.dart';
import 'package:arogyamate/screens/app_pages/notifications/notifications_screen.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/search_item/deparment_searchFilter.dart';
import 'package:arogyamate/widgets/widgets.dart';
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
                  // --- Header & Banner & Departments (Scrollable) ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isPhone ? 16 : 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          GreetingHeader(
                            onNotificationTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const NotificationsScreen(),
                                ),
                              );
                            },
                            trailing: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AnalyticsScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  ),
                                ),
                                child: Icon(
                                  Icons.bar_chart_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const PromoBanner(),
                          const SizedBox(height: 20),
                          Consumer<DoctorController>(
                            builder: (context, ctrl, _) => DepartmentSelector(
                              selectedDepartment: ctrl.selectedDepartment,
                              onDepartmentSelected: (dept) {
                                ctrl.setSelectedDepartment(dept);
                                ctrl.search(search.text);
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  // --- Sticky Search & Toggle ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: isPhone ? 135 : 145,
                      maxHeight: isPhone ? 135 : 145,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: isPhone ? 16 : 24, vertical: 8),
                        child: Consumer<DoctorController>(
                          builder: (context, ctrl, _) => Column(
                            children: [
                              ModernSearchBar(
                                hint: 'Search specialists...',
                                controller: search,
                                onFilterPressed: () => ctrl.toggleSearchContainer(),
                                onClearPressed: () {
                                  ctrl.setShowSearchContainer(false);
                                  ctrl.clearFilter();
                                },
                                onSearch: (val) => ctrl.search(val),
                              ),
                              const SizedBox(height: 12),
                              PillToggleSwitch(
                                labels: const ['Day Shift', 'Night Shift'],
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
                                fontSize: 17,
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
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: isPhone ? 12 : 20, vertical: 5),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => DoctorCard(
                              doctor: filteredDoctors[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DoctorView(doctor: filteredDoctors[index]),
                                  ),
                                );
                              },
                            ),
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
