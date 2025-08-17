import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practice/doctor/doctor_list_page.dart';
import 'package:practice/patient/chat_list_page.dart';
import 'package:practice/profile_page.dart';
import 'package:practice/setting_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    DoctorListPage(),
    ChatListPage(),
    ProfilePage(),
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
          backgroundColor: Color.fromARGB(255, 34, 64, 212),
          unselectedItemColor: Color(0xffBEBEBE),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: AppLocalizations.of(context)!.home,
            ),
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
