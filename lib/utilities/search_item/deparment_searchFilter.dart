import 'package:arogyamate/controllers/doctor_controller.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorSearchFilter extends StatefulWidget {
  final bool isPhone;
  final Function(String?, String?, int?, double?) onFiltersSelected;
  final bool showAgefilter;
  final bool showFeesfilter;
  const DoctorSearchFilter({
    required this.isPhone,
    required this.onFiltersSelected,
    super.key,
    this.showAgefilter = true,
    this.showFeesfilter = true,
  });

  @override
  State<DoctorSearchFilter> createState() => _DoctorSearchFilterState();
}

class _DoctorSearchFilterState extends State<DoctorSearchFilter> {
  void applyFilters() {
    final ctrl = context.read<DoctorController>();
    widget.onFiltersSelected(
        ctrl.selectedDepartment, ctrl.selectedQualification, ctrl.selectedAge, ctrl.selectedFees);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<DoctorController>();
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
          SizedBox(height: 12),
          SizedBox(
            width: isPhone(context) ? s.width * 0.9 : s.width * 0.5,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: _buildDropdown(
                    'Department',
                    ctrl.departments,
                    ctrl.selectedDepartment,
                    (val) {
                      context.read<DoctorController>().setFilterSelections(department: val);
                      applyFilters();
                    },
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 120,
                  child: _buildDropdown(
                    'Qualification',
                    ctrl.qualifications,
                    ctrl.selectedQualification,
                    (val) {
                      context.read<DoctorController>().setFilterSelections(qualification: val);
                      applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          if (widget.showAgefilter || widget.showFeesfilter)
            SizedBox(
              width: isPhone(context) ? s.width * 0.9 : s.width * 0.5,
              child: Row(
                children: [
                  if (widget.showAgefilter)
                    SizedBox(
                      width: 120,
                      child: _buildDropdown(
                        'Age',
                        ctrl.ages.map((e) => e.toString()).toList(),
                        ctrl.selectedAge?.toString(),
                        (val) {
                          context.read<DoctorController>().setFilterSelections(
                              age: val != null ? int.tryParse(val) : null);
                          applyFilters();
                        },
                      ),
                    ),
                  if (widget.showAgefilter && widget.showFeesfilter) Spacer(),
                  if (widget.showFeesfilter)
                    SizedBox(
                      width: 120,
                      child: _buildDropdown(
                        'Fees',
                        ctrl.fees.map((e) => e.toString()).toList(),
                        ctrl.selectedFees?.toString(),
                        (val) {
                          context.read<DoctorController>().setFilterSelections(
                              fees: val != null ? double.tryParse(val) : null);
                          applyFilters();
                        },
                      ),
                    ),
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
