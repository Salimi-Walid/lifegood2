import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lifegood/screen/todo.dart';
import 'package:lifegood/screen/hobise.dart';
import 'package:lifegood/screen/notes.dart';
import 'package:lifegood/screen/paramitre_user.dart';

class GoogleNavBar extends StatefulWidget {
  const GoogleNavBar({super.key});

  @override
  State<GoogleNavBar> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Hobbies(),
    Notes(),
    Todo(),
    ParamitreUser(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
        backgroundColor: Colors.black,
        activeColor: Colors.white,
        color: Colors.white,
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
        tabs: [
          GButton(icon: Icons.interests, text: "Hobies"),
          GButton(icon: Icons.edit_note, text: "Notes"),
          GButton(icon: Icons.timeline, text: "Evolution"),
          GButton(icon: Icons.settings, text: "Settings"),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
