import 'dart:io';

import 'package:arogyamate/core/session/session_manager.dart';
import 'package:arogyamate/screens/app_pages/profile_info/about_us.dart';
import 'package:arogyamate/screens/app_pages/profile_info/help.dart';
import 'package:arogyamate/screens/app_pages/profile_info/terms_conditions.dart';
import 'package:arogyamate/screens/login_info/start_screen.dart';
import 'package:arogyamate/core/theme/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    getImage();
    getText();
  }

  Future<void> getImage() async {
    image = await SessionManager.getProfileImage();
    setState(() {});
  }

  String? image;

  Future<void> getText() async {
    textt = await SessionManager.getHospitalName();
    id = await SessionManager.getHospitalId();
    setState(() {});
  }

  String? textt = '';
  String? id = '';
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isPhone ? 20 : 280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isPhone ? 30 : 30),
                  const Align(
                    alignment: Alignment.topRight,
                    child: ThemeToggleButton(),
                  ),
                  _buildProfileAvatar(isPhone),
                  SizedBox(height: isPhone ? 25 : 30),
                  _buildInfoCard(isPhone, s),
                  SizedBox(height: isPhone ? 110 : 60),
                  _buildSignOutButton(isPhone, s),
                  SizedBox(height: isPhone ? 30 : 70),
                  Container(
                    width: isPhone?s.width:s.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HelpPage()));
                          },
                          child: Text(
                            'Help?',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 10),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutUsPage()));
                          },
                          child: Text(
                            'About Us',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 10),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndConditionsPage()));
                          },
                          child: Text(
                            'Terms&Conditions',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildProfileAvatar(bool isPhone) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey[300],
          backgroundImage: (image != null && image!.isNotEmpty)
              ?(kIsWeb?NetworkImage(image!) as ImageProvider: FileImage(File(image!)))
              : AssetImage('assets/images/hospital.jpg'),
          child: (image == null ||image!.isEmpty )
              ? Icon(Icons.photo_camera_outlined,
                  size: 40, color: Colors.black54)
              : SizedBox(),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isPhone, Size s) {
    return Container(
      width: isPhone ? s.width * 0.9 : s.width * 0.5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       height: isPhone ? 40 : 45,
          //       width: isPhone ? 40 : 45,
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [Colors.blue[400]!, Colors.blue[600]!],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: IconButton(
          //         onPressed: () {},
          //         icon: const Icon(Icons.edit, color: Colors.white, size: 20),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10),
          _buildDetailRow(isPhone, 'Hospital', textt),
          _buildDetailRow(isPhone, 'ID', id),
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
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: isPhone ? 15 : 17,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
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
            color: Colors.red.withOpacity(0.3),
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
          backgroundColor: Colors.red[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          'Sign Out',
          style: GoogleFonts.poppins(
            color: Colors.white,
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
