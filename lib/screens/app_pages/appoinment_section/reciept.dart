import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:provider/provider.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/screens/app_pages/appoinment_section/edit_appoinment.dart';
import 'package:arogyamate/utilities/search_item/searchbar_appoinment.dart';
import 'package:flutter/material.dart';

class RecieptPage extends StatefulWidget {
  final AppointModel? appoint;
  const RecieptPage({super.key, this.appoint});

  @override
  State<RecieptPage> createState() => _RecieptPageState();
}

class _RecieptPageState extends State<RecieptPage> {
  final TextEditingController searchMe = TextEditingController();
  bool showSearchContainer = false;
  String? selectedDepartment;
  String? selectedDoctor;
  String? selectedBlood;
  String? selectedAddress;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<AppointmentController>();
      if (mounted) {
        setState(() {
          departments = ctrl.appointments
              .map((d) => d.department ?? '')
              .where((d) => d.isNotEmpty)
              .toSet()
              .toList();
          doctor = ctrl.appointments
              .map((d) => d.doctorName ?? '')
              .where((q) => q.isNotEmpty)
              .toSet()
              .toList();
          blood = ctrl.appointments
              .map((b) => b.blood ?? "")
              .where((b) => b.isNotEmpty)
              .toSet()
              .toList();
          address = ctrl.appointments
              .map((a) => a.address ?? "")
              .where((a) => a.isNotEmpty)
              .toSet()
              .toList();
        });
      }
    });
  }

  List<String> departments = [];
  List<String> doctor = [];
  List<String> blood = [];
  List<String> address = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isPhone = constraints.maxWidth < 600;
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isPhone ? 15 : 30,
                  vertical: isPhone ? 20 : 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointments',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 25),
                    CommonSearch1(
                      isPhone: isPhone,
                      hint: "Search",
                      controller: searchMe,
                      onFilterPressed: () {
                        setState(() {
                          showSearchContainer = !showSearchContainer;
                        });
                      },
                      onClearPressed: () {
                        setState(() {
                          showSearchContainer = false;
                          selectedDoctor = null;
                          selectedDepartment = null;
                          selectedBlood = null;
                          selectedAddress = null;
                        });
                      },
                      onSearch: (value) => context.read<AppointmentController>().search(value),
                    ),
                    if (showSearchContainer)
                      AppoinmentSearchFilter(
                          isPhone: isPhone,
                          onFiltersSelected:
                              (department, doctor, bloodGroup, address) {
                            setState(() {
                              selectedDepartment = department;
                              selectedDoctor = doctor;
                              selectedBlood = bloodGroup;
                              selectedAddress = address;
                            });
                            context.read<AppointmentController>().search(searchMe.text);
                          }),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Consumer<AppointmentController>(
                        builder:
                            (context, ctrl, _) {
                          final appoinmentList = ctrl.appointments;
                          final filterAppoinment =
                              appoinmentList.where((patient) {
                            bool setDepartment = selectedDepartment == null ||
                                patient.department == selectedDepartment;
                            bool setDoctor = selectedDoctor == null ||
                                patient.doctorName == selectedDoctor;
                            bool setBlood = selectedBlood == null ||
                                patient.blood == selectedBlood;
                            bool setAdderss = selectedAddress == null ||
                                patient.address == selectedAddress;
                            return setDepartment &&
                                setDoctor &&
                                setBlood &&
                                setAdderss;
                          }).toList();
                          if (appoinmentList.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 60,
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'No appointments found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: filterAppoinment.length,
                            itemBuilder: (context, index) {
                              final data = filterAppoinment[index];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color:
                                          // ignore: deprecated_member_use
                                          Theme.of(context).shadowColor.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data.name ?? 'No Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${data.date ?? 'N/A'} ${data.time ?? ''}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditAppoinment(
                                                          appoint: data,
                                                        )));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                          onPressed: () {
                                            _deleteAppointment(
                                                context, data, index);
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow(context, Icons.person,
                                                  'Age: ${data.age ?? 'N/A'}'),
                                              _buildInfoRow(context, Icons.bloodtype,
                                                  'Blood: ${data.blood ?? 'N/A'}'),
                                              _buildInfoRow(context,
                                                  Icons.medical_services,
                                                  'Dr: ${data.doctorName ?? 'N/A'}'),
                                            ],
                                          ),
                                        ),
                                        
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow(context,
                                                  Icons.local_hospital,
                                                  'Dept: ${data.department ?? 'N/A'}'),
                                              _buildInfoRow(context, Icons.location_on,
                                                  'Addr: ${data.address ?? 'N/A'}'),
                                              _buildInfoRow(context, Icons.phone,
                                                  'Ph: ${data.phone ?? 'N/A'}'),
                                            ],
                                          ),
                                        ),
                                      ],
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(
      BuildContext context, AppointModel appointment, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content:
            const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppointmentController>().delete(appointment.id!);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
