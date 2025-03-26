import 'package:arogyamate/utilities/colors/addpages_color.dart';
import 'package:arogyamate/utilities/constant/media_query.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NumberField extends StatefulWidget {
  FormFieldValidator<String> validate;

  String hint;
  TextEditingController controller;
  NumberField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.validate});

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: widget.controller,
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
          )),
      validator: widget.validate,
    );
  }
}

//---------------------------------------------------------------Years of experience
String? validateYearsOfExperience(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter years of experience';
  }
  final years = int.tryParse(value);
  if (years == null) {
    return 'Please enter a valid number';
  }
  if (years < 0) {
    return 'Years of experience cannot be negative';
  }
  return null;
}

//------------------------------------------------------------------Fees validator
String? validateFees(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter consultation fees';
  }
  final fees = double.tryParse(value);
  if (fees == null) {
    return 'Please enter a valid amount';
  }
  if (fees < 0) {
    return 'Fees cannot be negative';
  }
  return null;
}
//------------------------------------------------------------------------age validator

SizedBox  ageField(
    BuildContext context, bool isPhone, TextEditingController controller) {
  double width = MediaQuery.of(context).size.width * (isPhone ? 0.29 : 0.1);

  return SizedBox(
    width: width,
    child: TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Enter Age',
        hintStyle: TextStyle(
          color: Colors.black45,
        ),
      ),
      validator: (value) {
        RegExp ageRegExp = RegExp(r"^\d+$");

        if (value == null || value.isEmpty) {
          return 'Age is required';
        }
        if (!ageRegExp.hasMatch(value)) {
          return 'Enter a valid age';
        }

        int age = int.parse(value);
        if (age > 150 || age <= 0) {
          return 'Give a valid age';
        }
        return null;
      },
    ),
  );
}

//-----------------------------------------------------------------------Phone number validator
SizedBox phoneNumberField(bool isPhone, TextEditingController controller, BuildContext context) {
  double fieldWidth = isPhone ? s.width * 0.567 :s.width* 0.74; // Define before returning

  return SizedBox(
    width: fieldWidth, // Use calculated width here
    child: TextFormField(
      keyboardType: TextInputType.phone, // Better for web input handling
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
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
        contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Mobile number',
        hintStyle: TextStyle(
          color: Colors.black45,
        ),
      ),
      validator: (value) {
        RegExp phoneRegExp = RegExp(r"^\+?[0-9]{10,15}$");

        if (value == null || value.isEmpty) {
          return 'Number required';
        }
        if (!phoneRegExp.hasMatch(value)) {
          return 'Enter a valid number';
        }

        return null;
      },
    ),
  );
}


//------------------------------------------------age validator
String? ageValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Age cannot be empty';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Only numbers are allowed';
  } else {
    int age = int.tryParse(value) ?? 0;
    if (age < 1 || age > 120) {
      return 'Enter a valid age (1-120)';
    }
  }
  return null;
}

//--------------------------------------------------------Phonenumber
String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  } else if (value.length < 10) {
    return 'Phone number must be exactly 10 digits';
  } else if (value.length > 10) {
    return 'Phone number cannot be more than 10 digits';
  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
    return 'Phone number must contain only numbers';
  }
  return null;
}


//-----------------------------------------------------------Experience validator
String? experienceValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Experience is required';
  }
  final int? years = int.tryParse(value);
  if (years == null || years < 3) {
    return 'Experience must be at least 3 years';
  }
  return null;
}

//----------------------------------------------------------Fees
String? feesValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Fees are required';
  }
  final int? fee = int.tryParse(value);
  if (fee == null || fee < 100) {
    return 'Fees must be at least 100';
  }
  return null;
}
