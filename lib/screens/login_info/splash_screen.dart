// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:arogyamate/core/session/session_manager.dart';
import 'package:arogyamate/screens/login_info/start_screen.dart';
import 'package:arogyamate/screens/login_info/welcome_screen.dart';
import 'package:arogyamate/utilities/app_essencials/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    Future.delayed(Duration(seconds: 3),()async{await getLoggCheck();});
  }
 
  Future<void> getLoggCheck() async {
    final bool hasSeen = await SessionManager.hasSeenWelcome();
    final bool userLoggedIn = await SessionManager.isLoggedIn();
    if (!mounted) return;
    if (!hasSeen) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else if (userLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SelectionPage()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo with soft shadow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(seconds: 2),
                  child: Image.asset(
                    'assets/images/spash logo.jpeg',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            // AROGYA text
            SizedBox(
              width: 200,
              height: 200,
              child: ArcText(
                radius: 100,
                text: "AROGYA",
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                  letterSpacing: 1.5,
                ),
                startAngle: -pi / 2,
                stretchAngle: pi / 2,
              ),
            ),
            
            // MATE text
            SizedBox(
              width: 200,
              height: 200,
              child: ArcText(
                radius: 100,
                text: "MATE",
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26A69A), 
                  letterSpacing: 1.5,
                ),
                startAngle: 0,
                stretchAngle: pi / 2,
              ),
            ),
            
            // App version at the bottom
            Positioned(
              bottom: 50,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 2),
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}