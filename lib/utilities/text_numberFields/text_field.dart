import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextsField extends StatefulWidget {
  String hint;
  TextEditingController controller;
  IconButton?  TrailingIcon;
  TextsField({super.key, required this.hint, required this.controller,this.TrailingIcon});

  @override
  State<TextsField> createState() => _TextsFieldState();
}

class _TextsFieldState extends State<TextsField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: widget.controller,
      autovalidateMode:AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              // ignore: deprecated_member_use
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
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
            borderSide: BorderSide(
              color: primaryColor,
              width: 1.8,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 13),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.black45,
          ),
          suffixIcon: widget.TrailingIcon,
          ),

      validator: (value) {
        RegExp nameRegExp = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ' -]+$");

        if (value == null || value.isEmpty) {
          return 'This field is required';
        } else if (!nameRegExp.hasMatch(value)) {
          return 'Enter a valid text';
        }
        return null;
      },
    );
  }
}

//----------------------------------------------------------------Name validator
String? nameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Name cannot be empty';
  } else if (value.trim().length < 3) {
    return 'Name must be at least 3 characters long';
  } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return 'Only letters and spaces allowed';
  }
  return null;
}
