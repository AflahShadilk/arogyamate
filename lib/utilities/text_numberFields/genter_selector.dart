import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable

class GenderSelector extends StatefulWidget {
  final GlobalKey<FormFieldState<String>> genderKey;

  const GenderSelector({
    super.key,
    required this.genderKey,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GenderSelectorState createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 100,
      child: DropdownButtonFormField<String>(
        key: widget.genderKey,
        decoration: InputDecoration(
          hintText: 'Gender',
          hintStyle: TextStyle(
            color: Colors.black45,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.8,
            ),
          ),
        ),
        value: selectedGender,
        items: ["Men", "Women", "Other"].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
          widget.genderKey.currentState?.validate();
        },
        validator: (value) => value == null ? 'Please select' : null,
      ),
    );
  }
}

// ignore: must_be_immutable
class TitleSelector extends StatefulWidget {
  final GlobalKey<FormFieldState<String>> titlekey;
  const TitleSelector({super.key, required this.titlekey});

  @override
  // ignore: library_private_types_in_public_api
  _TitleSelectorState createState() => _TitleSelectorState();
}

class _TitleSelectorState extends State<TitleSelector> {
  String? selectedTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 75,
      child: DropdownButtonFormField<String>(
        key: widget.titlekey,
        decoration: InputDecoration(
          labelText: 'Mr./Ms.',
          labelStyle: const TextStyle(fontSize: 12), // Smaller label
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1.8,
            ),
          ),
        ),
        value: selectedTitle,
        items: ["Mr.", "Ms."].map((String title) {
          return DropdownMenuItem<String>(
            value: title,
            child: Text(title, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedTitle = newValue;
          });
          widget.titlekey.currentState?.validate();
        },
        validator: (value) => value == null ? 'Please select' : null,
      ),
    );
  }
}
