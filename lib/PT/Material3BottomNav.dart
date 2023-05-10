import 'package:flutter/material.dart';
import 'package:frontend/PT/ProfilePT.dart';

import 'SchedulePT.dart';

class Material3BottomNav extends StatefulWidget {
  Material3BottomNav({Key? key, required int selectedIndex}) : super(key: key);
  int selectedIndex = 0;
  @override
  State<Material3BottomNav> createState() => _Material3BottomNavState( selectedIndex);
}

class _Material3BottomNavState extends State<Material3BottomNav> {
  int _selectedIndex;

  _Material3BottomNavState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    return
      NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return SchedulePT();}));
              break;
            case 1:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return ProfilePT();}));
              break;
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
      );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.fitness_center_outlined),
    selectedIcon: Icon(Icons.fitness_center_rounded),
    label: 'Lịch',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline_rounded),
    selectedIcon: Icon(Icons.person_rounded),
    label: 'Hồ Sơ',
  ),
];
