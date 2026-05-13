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
      body: Stack(
        children: [
          // Background Gradient Header
          Container(
            height: s.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isPhone ? 20 : s.width * 0.3),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        ),
                        const ThemeToggleButton(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hospital Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Main Content Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Consumer<SessionController>(
                            builder: (context, session, _) => _buildProfileAvatar(isPhone, session.profileImage),
                          ),
                          const SizedBox(height: 25),
                          Consumer<SessionController>(
                            builder: (context, session, _) => _buildInfoSection(isPhone, session.hospitalName, session.hospitalId),
                          ),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 20),
                          _buildMenuLink(Icons.help_outline_rounded, "Help & Support", () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpPage()));
                          }),
                          _buildMenuLink(Icons.info_outline_rounded, "About Us", () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage()));
                          }),
                          _buildMenuLink(Icons.description_outlined, "Terms & Conditions", () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditionsPage()));
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildSignOutButton(isPhone, s),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileAvatar(bool isPhone, String? image) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        backgroundImage: (image != null && image!.isNotEmpty)
            ? (kIsWeb ? NetworkImage(image!) as ImageProvider : FileImage(File(image!)))
            : const AssetImage('assets/images/hospital.jpg') as ImageProvider,
        child: (image == null || image!.isEmpty)
            ? Icon(Icons.local_hospital_rounded, size: 45, color: Theme.of(context).colorScheme.primary)
            : const SizedBox(),
      ),
    );
  }

  Widget _buildInfoSection(bool isPhone, String? hospitalName, String? hospitalId) {
    return Column(
      children: [
        Text(
          hospitalName ?? "ArogyaMate Hospital",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "ID: ${hospitalId ?? 'AR-2024-001'}",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuLink(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }



  Widget _buildSignOutButton(bool isPhone, Size s) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () async {
          await logout();
        },
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          'Sign Out',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
          foregroundColor: Theme.of(context).colorScheme.error,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Theme.of(context).colorScheme.error, width: 1),
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
