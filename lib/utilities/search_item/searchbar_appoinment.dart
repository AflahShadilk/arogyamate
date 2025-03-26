import 'package:arogyamate/data_base/functions/db_appoinment.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';

class CommonSearch1 extends StatefulWidget {
  final bool isPhone;
  final String hint;
  final TextEditingController controller;
  final Function(String)? onSearch;
  final VoidCallback onFilterPressed;
  final VoidCallback onClearPressed;

  const CommonSearch1({
    super.key,
    required this.isPhone,
    required this.hint,
    required this.controller,
    this.onSearch,
    required this.onFilterPressed,
    required this.onClearPressed,
  });

  @override
  State<CommonSearch1> createState() => _CommonSearch1State();
}

class _CommonSearch1State extends State<CommonSearch1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isPhone ? 0 : 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A5CFF), width: 2),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.grey[600]),
              onPressed: () {
                if (widget.onSearch != null) {
                  widget.onSearch!(widget.controller.text);
                }
              },
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onPressed: widget.onFilterPressed,
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClearPressed();
                    if (widget.onSearch != null) {
                      widget.onSearch!("");
                    }
                  },
                ),
              ],
            ),
          ),
          onChanged: (value) {
            if (widget.onSearch != null) {
              widget.onSearch!(value);
            }
          },
        ),
      ),
    );
  }
}
//------------------------------------------------------------------

class AppoinmentSearchFilter extends StatefulWidget {
  final bool isPhone;
  final Function(String?, String?, String?, String?) onFiltersSelected;

  const AppoinmentSearchFilter({
    required this.isPhone,
    required this.onFiltersSelected,
    super.key,
  });

  @override
  State<AppoinmentSearchFilter> createState() => _AppoinmentSearchFilterState();
}

class _AppoinmentSearchFilterState extends State<AppoinmentSearchFilter> {
  String? selectedDepartment;
  String? selectedDoctor;
  String? selectedBlood;
  String? selectedAddress;

  List<String> departments = [];
  List<String> doctor = [];
  List<String> blood = [];
  List<String> address = [];

  @override
  void initState() {
    super.initState();
    fetchFilterAppoinment().then((_) {
      if (mounted) {
        setState(() {
          departments = AppointmentNotifier.value
              .map((d) => d.department ?? '')
              .where((d) => d.isNotEmpty)
              .toSet()
              .toList();
          doctor = AppointmentNotifier.value
              .map((d) => d.doctorName ?? '')
              .where((q) => q.isNotEmpty)
              .toSet()
              .toList();
          blood = AppointmentNotifier.value
              .map((b) => b.blood ?? "")
              .where((b) => b.isNotEmpty)
              .toSet()
              .toList();
          address = AppointmentNotifier.value
              .map((a) => a.address ?? "")
              .where((a) => a.isNotEmpty)
              .toSet()
              .toList();
        });
      }
    });
  }

  void applyFilters() {
    widget.onFiltersSelected(
        selectedDepartment, selectedDoctor, selectedBlood, selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.isPhone ? 0 : 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A5CFF),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: isPhone(context)?s.width*0.9:s.width*0.5,
            child: Row(
              
              children: [
                SizedBox(
                  width: 120,
                  child: _buildDropdown(
                    'Department',
                    departments,
                    selectedDepartment,
                    (val) => setState(() {
                      selectedDepartment = val;
                      applyFilters();
                    }),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 120,
                  child: _buildDropdown(
                    'Doctor',
                    doctor,
                    selectedDoctor,
                    (val) => setState(() {
                      selectedDoctor = val;
                      applyFilters();
                    }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: isPhone(context)?s.width*0.9:s.width*0.5,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: _buildDropdown(
                      'Blood Group',
                      blood,
                      selectedBlood,
                      (val) => setState(() {
                            selectedBlood = val;
                            applyFilters();
                          })),
                ),
                Spacer(),
                SizedBox(
                    width: 120,
                    child: _buildDropdown(
                        "Address",
                        address,
                        selectedAddress,
                        (val) => setState(() {
                              selectedAddress = val;
                                  applyFilters();
                            }))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        DropdownButton<String>(
          value: selectedValue,
          hint: Text('Select '),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
