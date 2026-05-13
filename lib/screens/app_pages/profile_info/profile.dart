import 'dart:io';

import 'package:arogyamate/controllers/session_controller.dart';
import 'package:arogyamate/core/session/session_manager.dart';
import 'package:arogyamate/screens/app_pages/profile_info/about_us.dart';
import 'package:arogyamate/screens/app_pages/profile_info/help.dart';
import 'package:arogyamate/screens/app_pages/profile_info/terms_conditions.dart';
import 'package:arogyamate/screens/login_info/start_screen.dart';
import 'package:arogyamate/core/theme/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }








  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    bool isPhone = s.width < 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: s.height,
          width: s.width,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isPhone ? 20 : 280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.topRight,
                    child: ThemeToggleButton(),
                  ),
                  Consumer<SessionController>(
                    builder: (context, session, _) => Column(
                      children: [
                        _buildProfileAvatar(isPhone, session.profileImage),
                        const SizedBox(height: 25),
                        _buildInfoCard(isPhone, s, session.hospitalName, session.hospitalId),
                      ],
                    ),
                  ),
                  const SizedBox(height: 110),
                  _buildSignOutButton(isPhone, s),
                  const SizedBox(height: 30),
                  Container(
                    width: isPhone?s.width:s.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HelpPage()));
                          },
                          child: const Text(
                            'Help?',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutUsPage()));
                          },
                          child: const Text(
                            'About Us',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndConditionsPage()));
                          },
                          child: const Text(
                            'Terms&Conditions',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildProfileAvatar(bool isPhone, String? image) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          backgroundImage: (image != null && image!.isNotEmpty)
              ?(kIsWeb?NetworkImage(image!) as ImageProvider: FileImage(File(image!)))
              : const AssetImage('assets/images/hospital.jpg') as ImageProvider,
          child: (image == null ||image!.isEmpty )
              ? Icon(Icons.photo_camera_outlined,
                  size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant)
              : const SizedBox(),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isPhone, Size s, String? hospitalName, String? hospitalId) {
    return Container(
      width: isPhone ? s.width * 0.9 : s.width * 0.5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildDetailRow(isPhone, 'Hospital', hospitalName),
          _buildDetailRow(isPhone, 'ID', hospitalId),
        ],
      ),
    );
  }

  Widget _buildDetailRow(bool isPhone, String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isPhone ? 80 : 100,
            child: Text(
              '$title:',
              style: GoogleFonts.poppins(
                fontSize: isPhone ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: isPhone ? 15 : 17,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(bool isPhone, Size s) {
    return Container(
      width: isPhone ? s.width * 0.7 : s.width * 0.4,
      height: isPhone ? 55 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Theme.of(context).colorScheme.error.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          await logout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Sign Out',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onError,
            fontSize: isPhone ? 16 : 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    final signOut = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes')),
            ],
          );
        });
    if (signOut == true) {
      await SessionManager.logout();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SelectionPage()));
    }
  }
}
