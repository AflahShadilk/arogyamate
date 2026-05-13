import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:provider/provider.dart';
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Theme.of(context).shadowColor.withOpacity(0.1),
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
            fillColor: Theme.of(context).cardColor,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
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
                  icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.secondary),
                  onPressed: widget.onFilterPressed,
                ),
                IconButton(
                  icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
  void applyFilters() {
    final ctrl = context.read<AppointmentController>();
    widget.onFiltersSelected(
        ctrl.selectedDepartment, ctrl.selectedDoctor, ctrl.selectedBlood, ctrl.selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AppointmentController>();
    final filterData = ctrl.filterData;
    final departments = filterData['departments'] ?? [];
    final doctors = filterData['doctors'] ?? [];
    final blood = filterData['blood'] ?? [];
    final address = filterData['address'] ?? [];
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.isPhone ? 0 : 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isPhone(context)?s.width*0.9:s.width*0.5,
            child: Row(
              
              children: [
                 SizedBox(
                  width: 120,
                  child: _buildDropdown(
                    'Department',
                    departments,
                    ctrl.selectedDepartment,
                    (val) {
                      context.read<AppointmentController>().setFilterSelections(department: val);
                      applyFilters();
                    },
                  ),
                ),
                Spacer(),
                 SizedBox(
                  width: 120,
                  child: _buildDropdown(
                    'Doctor',
                    doctors,
                    ctrl.selectedDoctor,
                    (val) {
                      context.read<AppointmentController>().setFilterSelections(doctor: val);
                      applyFilters();
                    },
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
                      ctrl.selectedBlood,
                      (val) {
                            context.read<AppointmentController>().setFilterSelections(blood: val);
                            applyFilters();
                          }),
                ),
                Spacer(),
                 SizedBox(
                    width: 120,
                    child: _buildDropdown(
                        "Address",
                        address,
                        ctrl.selectedAddress,
                        (val) {
                              context.read<AppointmentController>().setFilterSelections(address: val);
                                  applyFilters();
                            })),
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
        const SizedBox(height: 5),
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
