import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildSectionTitle('1. Introduction'),
              buildParagraph('By using ArogyaMate, you agree to the following Terms and Conditions.'),
              buildSectionTitle('2. Use of the App'),
              buildBulletPoint('ArogyaMate is for offline hospital appointment booking only.'),
              buildBulletPoint('The app does not provide medical advice or treatment.'),
              buildBulletPoint('Users must ensure the accuracy of their provided information.'),
              buildSectionTitle('3. Privacy and Data Security'),
              buildBulletPoint('ArogyaMate stores appointment data securely on your device.'),
              buildBulletPoint('We do not share or sell personal data.'),
              buildBulletPoint('Users are responsible for keeping their device secure.'),
              buildSectionTitle('4. Limitation of Liability'),
              buildBulletPoint('ArogyaMate is not responsible for appointment delays or errors.'),
              buildBulletPoint('Availability of appointments is not guaranteed.'),
              buildSectionTitle('5. Changes to Terms'),
              buildParagraph('We reserve the right to update these terms at any time.'),
              SizedBox(height: 20),
              Text(
                '🚀 ArogyaMate – Making Healthcare Access Simple and Convenient.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
      ],
    );
  }
}
