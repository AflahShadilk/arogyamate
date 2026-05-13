import 'package:arogyamate/controllers/department_controller.dart';
import 'package:arogyamate/controllers/doctor_controller.dart';

import 'package:arogyamate/data_base/models/department_model.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/global_key.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showBottomSheet1(
    BuildContext context, bool isphone, TextEditingController control) {
  bool isPhone = s.width < 600;
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: isPhone ? s.height * 0.7 : s.height * 0.7,
          child: Column(
            children: [
              SizedBox(height: 20),
              Wrap(
                runSpacing: 30,
                spacing: 10,
                children: [
                  Column(
                    children: [
                      BottumSheetColumn(
                        hint: 'Add new',
                        icon: Icons.add,
                        colorr: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 10),
                      BottumSheetColumn2(
                        hint: 'Search',
                        icon: Icons.search_outlined,
                        colorr: Theme.of(context).colorScheme.secondary,
                        searchFunction: (val) => context.read<DepartmentController>().search(val),
                        searchFunction2: (val) => context.read<DepartmentController>().search(val),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: isPhone ? s.width * 0.95 : s.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3)
                  ),
                  child: Consumer<DepartmentController>(
                    builder: (context, deptCtrl, _) {
                      return deptCtrl.departments.isEmpty
                          ? Center(
                              child: Text(
                                'No Department Found!',
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                final data = deptCtrl.departments[index];
                                return GestureDetector(
                                  onTap: () {
                                    control.text = data.department;
                                    Navigator.pop(context);
                                  },
                                  child: ListTile(
                                    title: Text(data.department),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        bool deleted = await deptCtrl.delete(
                                            data.id!, data.department);
                                        if (!deleted) {
                                          showDialog(
                                              // ignore: use_build_context_synchronously
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Can't delete"),
                                                  content: const Text(
                                                      'Doctor currently using this department'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(context),
                                                        child: const Text('Ok'))
                                                  ],
                                                );
                                              });
                                        } else {
                                          control.clear();
                                        }
                                      },
                                      icon: Icon(Icons.delete_outline,
                                          color: Theme.of(context).colorScheme.error),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: deptCtrl.departments.length,
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//--------------------------------------------------------------------------sheet two
void showBottomSheetDoctor(
    BuildContext context, bool isphone, TextEditingController control) {
  bool isPhone = s.width < 600;
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: isPhone ? s.height * 0.7 : s.height * 0.7,
          child: Column(
            children: [
              SizedBox(height: 20),
              Wrap(
                runSpacing: 30,
                spacing: 10,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      BottumSheetColumn2(
                        hint: 'Search',
                        icon: Icons.search_outlined,
                        colorr: Theme.of(context).colorScheme.secondary,
                        searchFunction: (val) => context.read<DoctorController>().search(val),
                        searchFunction2: (val) => context.read<DoctorController>().search(val),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: isPhone ? s.width * 0.95 : s.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3)
                  ),
                  child: Consumer<DoctorController>(
                    builder: (context, doctorCtrl, _) {
                      return doctorCtrl.doctors.isEmpty
                          ? Center(
                              child: Text(
                                'No Doctor Found!',
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, int index) {
                                final data = doctorCtrl.doctors[index];
                                return GestureDetector(
                                  onTap: () {
                                    control.text = data.name!;
                                    Navigator.pop(context);
                                  },
                                  child: data.status == Constants.leave
                                      ? const SizedBox()
                                      : ListTile(
                                          title: Text(
                                            data.name!,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: Text(data.department!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ))),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: doctorCtrl.doctors.length,
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//---------------------------------------------------------------------------------------------column inside the bottomsheet
// ignore: must_be_immutable
class BottumSheetColumn extends StatefulWidget {
  String hint;
  IconData icon;
  Color colorr;
  BottumSheetColumn(
      {super.key,
      required this.hint,
      required this.icon,
      required this.colorr});

  @override
  State<BottumSheetColumn> createState() => _BottumSheetColumnState();
}

class _BottumSheetColumnState extends State<BottumSheetColumn> {
  final TextEditingController bottomAddKey = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isPhone = s.width < 600;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Form(
              key: bottumSheetForm,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    isPhone ? 20 : 30, 0, isPhone ? 20 : 30, 0),
                child: TextFormField(
                  controller: bottomAddKey,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Don't be Empty";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.fromLTRB(0, 0, isPhone ? 20 : 30, isPhone ? 20 : 30),
            child: SizedBox(
              height: isPhone ? s.height * 0.06 : s.height * 0.05,
              width: isPhone ? s.width * 0.15 : s.width * 0.04,
              child: ElevatedButton(
                onPressed: () {
                  onPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.colorr,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Icon(widget.icon),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onPressed() async {
    if (bottumSheetForm.currentState!.validate()) {
      final name = bottomAddKey.text.trim();
      if (name.isNotEmpty) {
        final department = DepartmentModel(department: name);
        // ignore: use_build_context_synchronously
        await context.read<DepartmentController>().add(department);
        bottomAddKey.clear();
        setState(() {});
      }
    }
  }
}

//---------------------------------------------------------------------------------------------------------Search reuse
// ignore: must_be_immutable
class BottumSheetColumn2 extends StatefulWidget {
  String hint;
  IconData icon;
  Color colorr;
  final Function(String)? searchFunction;
  final Function(String)? searchFunction2;
  BottumSheetColumn2(
      {super.key,
      required this.hint,
      required this.icon,
      required this.colorr,
      this.searchFunction,
      this.searchFunction2});

  @override
  State<BottumSheetColumn2> createState() => _BottumSheetColumn2State();
}

class _BottumSheetColumn2State extends State<BottumSheetColumn2> {
  final TextEditingController bottomSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isPhone = s.width < 600;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Form(
              key: bottumSheetSearch,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    isPhone ? 20 : 30, 0, isPhone ? 20 : 30, 0),
                child: TextFormField(
                  onChanged: (value) {
                    if (widget.searchFunction != null) {
                      widget.searchFunction!(value);
                    }
                    setState(() {});
                  },
                  controller: bottomSearch,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Don't be Empty";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.fromLTRB(0, 0, isPhone ? 20 : 30, isPhone ? 20 : 30),
            child: SizedBox(
              height: isPhone ? s.height * 0.06 : s.height * 0.05,
              width: isPhone ? s.width * 0.15 : s.width * 0.04,
              child: ElevatedButton(
                onPressed: () {
                  widget.searchFunction2!(bottomSearch.text);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.colorr,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Icon(widget.icon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
