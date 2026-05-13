import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:arogyamate/utilities/validators/app_validators.dart';
import 'package:flutter/material.dart';

class NumberField extends StatefulWidget {
  final FormFieldValidator<String> validate;
  final String hint;
  final TextEditingController controller;

  const NumberField({
    super.key,
    required this.hint,
    required this.controller,
    required this.validate,
  });

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
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
      ),
      validator: widget.validate,
    );
  }
}

SizedBox ageField(BuildContext context, bool isPhone, TextEditingController controller) {
  double width = MediaQuery.of(context).size.width * (isPhone ? 0.29 : 0.1);

  return SizedBox(
    width: width,
    child: TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        fillColor: Theme.of(context).cardColor,
        filled: true,
        hintText: 'Age',
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
        ),
      ),
      validator: AppValidators.validateAge,
    ),
  );
}

SizedBox phoneNumberField(bool isPhone, TextEditingController controller, BuildContext context) {
  double fieldWidth = isPhone ? s.width * 0.567 : s.width * 0.74;

  return SizedBox(
    width: fieldWidth,
    child: TextFormField(
      keyboardType: TextInputType.phone,
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        fillColor: Theme.of(context).cardColor,
        filled: true,
        hintText: 'Mobile number',
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
        ),
      ),
      validator: AppValidators.validatePhone,
    ),
  );
}
