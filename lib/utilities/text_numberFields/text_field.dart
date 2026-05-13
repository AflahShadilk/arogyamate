
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextsField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final IconButton? TrailingIcon;
  final String? Function(String?)? validator;
  
  const TextsField({
    super.key, 
    required this.hint, 
    required this.controller,
    this.TrailingIcon,
    this.validator,
  });

  @override
  State<TextsField> createState() => _TextsFieldState();
}

class _TextsFieldState extends State<TextsField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.8,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 13),
        fillColor: Theme.of(context).cardColor,
        filled: true,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
        ),
        suffixIcon: widget.TrailingIcon,
      ),
      validator: widget.validator,
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
