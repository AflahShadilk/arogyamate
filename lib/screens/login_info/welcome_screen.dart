import 'package:arogyamate/screens/login_info/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
          
          return Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFEEF6FC)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height - MediaQuery.of(context).padding.vertical),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App logo or branding
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medical_services, color: Color(0xFF4cb3ec), size: isMobile ? 24 : 28),
                            const SizedBox(width: 8),
                            Text(
                              'ArogyaMate',
                              style: GoogleFonts.poppins(
                                fontSize: isMobile ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4cb3ec),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Main content
                      Column(
                        children: [
                          Container(
                            height: isMobile ? size.height * 0.35 : isTablet ? size.height * 0.4 : size.height * 0.45,
                            width: isMobile ? size.width * 0.8 : size.width * 0.5,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/icon/welcome.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            constraints: BoxConstraints(maxWidth: isMobile ? size.width * 0.85 : size.width * 0.6),
                            child: Text(
                              'Daily Journal for Hospital Management',
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: isMobile ? 24 : 32,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            constraints: BoxConstraints(maxWidth: isMobile ? size.width * 0.8 : size.width * 0.5),
                            child: Text(
                              'Manage doctors, patient records, and more using your mobile or web app.',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: isMobile ? 16 : 18,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      
                      // Call to action button
                      Padding(
                        padding: EdgeInsets.only(bottom: isMobile ? 32 : 48, top: 48),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async{
                                SharedPreferences prefs=await SharedPreferences.getInstance();
                                prefs.setBool('welcome',true);
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => SelectionPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4cb3ec),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 32 : 48,
                                  vertical: isMobile ? 16 : 20,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Let's Get Started",
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}