import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/doctor/doctor_chatlist_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:practice/setting_screen.dart';

import 'doctor_profile.dart';
import 'doctor_requests_page.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    DoctorRequestsPage(),
    DoctorChatlistPage(),
    DoctorProfile(),
    SettingsPage(),
  ];

  void _onItmTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWilPop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.areYouSure),
              content: Text(AppLocalizations.of(context)!.exitApp),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(AppLocalizations.of(context)!.no)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                    child: Text(AppLocalizations.of(context)!.yes)),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWilPop,
      child: Scaffold(
        body: _children.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xff0064FA),
          unselectedItemColor: Color(0xffBEBEBE),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: AppLocalizations.of(context)!.home),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                ),
                label: AppLocalizations.of(context)!.chat),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: AppLocalizations.of(context)!.profile),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: AppLocalizations.of(context)!.settings),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItmTapped,
        ),
      ),
    );
  }
}
