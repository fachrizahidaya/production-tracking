import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> handleNavigate;

  const NavBar(
      {super.key, required this.currentIndex, required this.handleNavigate});

  static const List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
    BottomNavigationBarItem(
        icon: Icon(Icons.notifications_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navItems,
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: handleNavigate,
    );
  }
}
