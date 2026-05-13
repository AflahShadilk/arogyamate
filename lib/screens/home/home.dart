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
                    horizontal: isPhone ? 10 : 20, vertical: isPhone ? 10 : 30),
                child: Column(
                  children: [
                    Consumer<SessionController>(
                      builder: (context, session, _) => Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            height: isPhone ? s.height * 0.2 : s.height * 0.3,
                            width: isPhone ? s.width * 0.9 : s.width * 0.6,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              image: (session.profileImage != null && session.profileImage!.isNotEmpty)
                                  ? DecorationImage(
                                      image: kIsWeb
                                          ? NetworkImage(session.profileImage!) as ImageProvider
                                          : FileImage(File(session.profileImage!)),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                            child: (session.profileImage == null || session.profileImage!.isEmpty)
                                ? Center(
                                    child: Icon(
                                      Icons.local_hospital_rounded,
                                      size: 60,
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Consumer<DoctorController>(
                      builder: (context, ctrl, _) => AppToggle(
                        firstOne: 'Day Shift',
                        secondOne: 'Night Shift',
                        selectedIndex: ctrl.selectedShift,
                        onToggle: _handleToggle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Consumer<DoctorController>(
                      builder: (context, ctrl, _) => Column(
                        children: [
                          SizedBox(
                            width: isPhone ? s.width * 0.88 : s.width * 0.9,
                            child: CommonSearch(
                              isPhone: isPhone,
                              hint: 'Search',
                              controller: search,
                              onFilterPressed: () => ctrl.toggleSearchContainer(),
                              onClearPressed: () {
                                ctrl.setShowSearchContainer(false);
                                ctrl.clearFilter();
                              },
                              onSearch: (val) => ctrl.search(val),
                            ),
                          ),
                          if (ctrl.showSearchContainer)
                            DoctorSearchFilter(
                              isPhone: isPhone,
                              showAgefilter: false,
                              showFeesfilter: false,
                              onFiltersSelected:
                                  (department, qualification, age, fees) {
                                ctrl.setFilterSelections(
                                      department: department,
                                      qualification: qualification,
                                    );
                                ctrl.search(search.text);
                              },
                            ),
                        ],
                      ),
                    ),
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                backgroundImage: (data.imagePath != null && data.imagePath!.isNotEmpty)
                    ? (kIsWeb
                        ? NetworkImage(data.imagePath!) as ImageProvider
                        : FileImage(File(data.imagePath!)))
                    : null,
                child: (data.imagePath == null || data.imagePath!.isEmpty)
                    ? Icon(Icons.person, size: 30, color: Theme.of(context).colorScheme.primary)
                    : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${data.startTime ?? 'N/A'} - ${data.endtime ?? ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                data.department!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
