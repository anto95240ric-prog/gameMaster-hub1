import 'package:go_router/go_router.dart';
import '../screens/home_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    // Exemple : SM Roster page
    // GoRoute(
    //   path: '/sm/roster',
    //   builder: (context, state) => const SmRosterPage(),
    // ),
  ],
);
