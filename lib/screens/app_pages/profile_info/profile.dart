import 'dart:io';

import 'package:arogyamate/screens/app_pages/profile_info/about_us.dart';
import 'package:arogyamate/screens/app_pages/profile_info/help.dart';
import 'package:arogyamate/screens/app_pages/profile_info/terms_conditions.dart';
import 'package:arogyamate/screens/login_info/start_screen.dart';
import 'package:arogyamate/utilities/constant/theme_provid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    image = prefs.getString('image') ?? '';
    setState(() {});
  }

  String? image = '';
  getText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    textt = prefs.getString('name') ?? '';
    id = prefs.getString('id') ?? '';
    setState(() {});
  }

  String? textt = '';
  String? id = '';
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                  _buildDarkModeToggle(context),
                  _buildProfileAvatar(isPhone),
                  SizedBox(height: 25),
                  _buildInfoCard(isPhone, s),
                  SizedBox(height: 60),
                  _buildSignOutButton(isPhone, s),
                  SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildDarkModeToggle(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          icon: Icon(
            Icons.dark_mode,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[800],
            size: 28,
          ),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          tooltip: 'Dark Mode',
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
          backgroundImage: (image != null)
              ?kIsWeb?NetworkImage(image!): FileImage(File(image!))
              : AssetImage('assets/images/hospital.jpg'),
          child: (image == null )
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
            title: Text('Sign Out'),
            content: Text('Are you sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes')),
            ],
          );
        });
    // ignore: unrelated_type_equality_checks
    if (signOut == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('saveKey', false);
     await prefs.remove('saveKey');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SelectionPage()));
    }
  }
}
