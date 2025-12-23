import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/timeline_page.dart';
import 'pages/events_page.dart';
import 'pages/library_page.dart';
import 'widgets/floating_action_widget.dart';
import 'services/audio_recorder_service.dart';
import 'providers/timeline_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioRecorderService()),
        ChangeNotifierProvider(create: (_) => TimelineProvider()),
      ],
      child: const PrismaNoteApp(),
    ),
  );
}

class PrismaNoteApp extends StatelessWidget {
  const PrismaNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prisma Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/timeline',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/timeline',
            builder: (context, state) => const TimelinePage(),
          ),
          GoRoute(
            path: '/events',
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryPage(),
          ),
        ],
      ),
    ],
  );
}

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