import 'package:arogyamate/screens/app_pages/appoinment_section/reciept.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/add_doctor.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctors_list.dart';
import 'package:arogyamate/screens/home/home.dart';
import 'package:arogyamate/controllers/navigation_controller.dart';
import 'package:arogyamate/screens/app_pages/profile_info/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  final List<Widget> _pages = [
    HomePage(),
    RecieptPage(),
    AddPage(),
    DoctorPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, navCtrl, _) {
        return Scaffold(
          body: _pages[navCtrl.selectedIndex],
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: GNav(
                  // ignore: deprecated_member_use
                  rippleColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  // ignore: deprecated_member_use
                  hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  haptic: true,
                  tabBorderRadius: 30,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 400),
                  gap: 6,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  iconSize: 24,
                  backgroundColor: Theme.of(context).cardColor,
                  tabBackgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  tabs: const [
                    GButton(icon: LineIcons.home, text: 'Home'),
                    GButton(icon: LineIcons.receipt, text: 'Receipt'),
                    GButton(icon: LineIcons.plusCircle, text: 'Add'),
                    GButton(icon: LineIcons.hospital, text: 'Doctor'),
                    GButton(icon: LineIcons.user, text: 'Profile')
                  ],
                  selectedIndex: navCtrl.selectedIndex,
                  onTabChange: (index) => navCtrl.setIndex(index),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
