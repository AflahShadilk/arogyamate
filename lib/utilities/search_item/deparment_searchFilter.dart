import 'package:arogyamate/data_base/functions/db_doctorfuctions.dart';
import 'package:arogyamate/utilities/constant/constants.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';

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
  String? selectedDepartment;
  String? selectedQualification;
  int? selectedAge;
  double? selectedFees;

  List<String> departments = [];
  List<String> qualifications = [];
  List<int> ages = [];
  List<double> fees = [];

  @override
  void initState() {
    super.initState();
    fetchFilterData().then((_) {
      if (mounted) {
        setState(() {
          departments = doctorNotifier.value
              .map((d) => d.department ?? '')
              .where((d) => d.isNotEmpty)
              .toSet()
              .toList();
          qualifications = doctorNotifier.value
              .map((d) => d.qualification ?? '')
              .where((q) => q.isNotEmpty)
              .toSet()
              .toList();
          ages = doctorNotifier.value
              .map((d) => int.tryParse(d.years ?? '') ?? 0)
              .where((a) => a > 0)
              .toSet()
              .toList();
          fees = doctorNotifier.value
              .map((d) => double.tryParse(d.fees ?? '') ?? 0.0)
              .where((f) => f > 0.0)
              .toSet()
              .toList();
        });
      }
    });
  }

  void applyFilters() {
    widget.onFiltersSelected(
        selectedDepartment, selectedQualification, selectedAge, selectedFees);
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
            width: isPhone(context) ? s.width * 0.9 : s.width * 0.5,
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
                    'Qualification',
                    qualifications,
                    selectedQualification,
                    (val) => setState(() {
                      selectedQualification = val;
                      applyFilters();
                    }),
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
                        ages.map((e) => e.toString()).toList(),
                        selectedAge?.toString(),
                        (val) => setState(() {
                          selectedAge = val != null ? int.tryParse(val) : null;
                          applyFilters();
                        }),
                      ),
                    ),
                  if (widget.showAgefilter && widget.showFeesfilter) Spacer(),
                  if (widget.showFeesfilter)
                    SizedBox(
                      width: 120,
                      child: _buildDropdown(
                        'Fees',
                        fees.map((e) => e.toString()).toList(),
                        selectedFees?.toString(),
                        (val) => setState(() {
                          selectedFees =
                              val != null ? double.tryParse(val) : null;
                          applyFilters();
                        }),
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
