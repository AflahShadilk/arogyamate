import 'package:arogyamate/screens/app_pages/appoinment_section/reciept.dart';
import 'package:arogyamate/screens/app_pages/doctor_section/doctors_list.dart';
import 'package:arogyamate/screens/home/home.dart';
import 'package:arogyamate/controllers/navigation_controller.dart';
import 'package:arogyamate/screens/app_pages/profile_info/profile.dart';
import 'package:arogyamate/widgets/common/in_app_toast_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    HomePage(),
    DoctorPage(),
    RecieptPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, navCtrl, _) {
        return Scaffold(
          body: Stack(
            children: [
              // Main Screen Page
              _pages[navCtrl.selectedIndex],

              const InAppToastBanner(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.06),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: GNav(
                  rippleColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.15),
                  hoverColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.05),
                  haptic: true,
                  tabBorderRadius: 20,
                  curve: Curves.easeInOutCubic,
                  duration: const Duration(milliseconds: 350),
                  gap: 8,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.7),
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  iconSize: 22,
                  backgroundColor: Theme.of(context).cardColor,
                  tabBackgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  tabs: const [
                    GButton(icon: Icons.home_rounded, text: 'Home'),
                    GButton(
                        icon: Icons.medical_services_rounded, text: 'Doctors'),
                    GButton(
                        icon: Icons.calendar_today_rounded,
                        text: 'Appointments'),
                    GButton(icon: Icons.person_rounded, text: 'Profile'),
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
