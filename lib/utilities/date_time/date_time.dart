import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  const DatePickerField({super.key, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        widget.controller.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: "Select Date",
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}

class TimePickerField extends StatefulWidget {
  final TextEditingController controller;
  const TimePickerField({super.key, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _TimePickerFieldState createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return; // If user cancels, exit the function

    TimeOfDay now = TimeOfDay.now();
    int nowMinutes = now.hour * 60 + now.minute;
    int pickedMinutes = pickedTime.hour * 60 + pickedTime.minute;

    if (pickedMinutes < nowMinutes) {
      // ignore: use_build_context_synchronously
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You cannot select a past time!")),
      );
      return; // Prevent setting the past time
    }

    // Formatting the selected time
    String formattedTime =
        "${pickedTime.hourOfPeriod.toString().padLeft(2, '0')}:"
        "${pickedTime.minute.toString().padLeft(2, '0')} "
        "${pickedTime.period == DayPeriod.am ? "AM" : "PM"}";

    setState(() {
      widget.controller.text = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: "Select Time",
          suffixIcon: Icon(Icons.access_time),
        ),
        onTap: () => _selectTime(context),
      ),
    );
  }
}
