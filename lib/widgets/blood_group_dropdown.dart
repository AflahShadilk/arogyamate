import 'package:flutter/material.dart';

class BloodGroupController extends ChangeNotifier {
  String? _selectedBloodGroup;

  String? get selectedBloodGroup => _selectedBloodGroup;

  void setBloodGroup(String? bloodGroup) {
    _selectedBloodGroup = bloodGroup;
    notifyListeners();
  }

  void clear() {
    _selectedBloodGroup = null;
    notifyListeners();
  }
}

class BloodGroupDropdown extends StatefulWidget {
  final BloodGroupController controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const BloodGroupDropdown({
    super.key,
    required this.controller,
    this.onSaved,
    this.validator,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BloodGroupDropdownState createState() => _BloodGroupDropdownState();
}

class _BloodGroupDropdownState extends State<BloodGroupDropdown> {
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
    'None'
  ];

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: widget.controller.selectedBloodGroup,
              hint: const Text("Select "),
              items: bloodGroups.map((String bloodGroup) {
                return DropdownMenuItem<String>(
                  value: bloodGroup,
                  child: Text(bloodGroup),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  widget.controller.setBloodGroup(newValue);
                  state.didChange(newValue);
                });
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  state.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
