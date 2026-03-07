import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'floating_action_widget.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.timeline),
      activeIcon: Icon(Icons.timeline),
      label: 'Timeline',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.work),
      activeIcon: Icon(Icons.work),
      label: 'Events',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.library_books),
      activeIcon: Icon(Icons.library_books),
      label: 'Library',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/timeline');
        break;
      case 1:
        context.go('/events');
        break;
      case 2:
        context.go('/library');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      floatingActionButton: const FloatingActionWidget(),
    );
  }
}
