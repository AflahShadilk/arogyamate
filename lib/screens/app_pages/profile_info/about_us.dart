import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50,),
            Text(
              'Welcome to ArogyaMate',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'ArogyaMate is your trusted offline hospital appointment booking companion. '
              'We aim to make healthcare access seamless, even without an internet connection.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Why Choose ArogyaMate?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildBulletPoint('Offline Functionality – Book appointments without internet.'),
            buildBulletPoint('User-Friendly – Simple interface for all age groups.'),
            buildBulletPoint('Fast & Reliable – Securely stores booking history.'),
            buildBulletPoint('Hospital Integration – Works with hospitals and clinics.'),
            const SizedBox(height: 20),
            Text(
              '🚀 ArogyaMate – Healthcare, Anytime, Anywhere.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
