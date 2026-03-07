import 'package:go_router/go_router.dart';
import '../pages/timeline_page.dart';
import '../pages/events_page.dart';
import '../pages/library_page.dart';
import '../widgets/main_scaffold.dart';

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
