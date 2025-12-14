import 'package:go_router/go_router.dart';
import 'package:my_trips/services/auth_wraper.dart';
import '../screens/add_trip/add_trip_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/signin_screen.dart';
import '../screens/home/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/', builder: (_, index) => const AuthWrapper()),
    GoRoute(path: '/login', builder: (_, index) => const SignInScreen()),
    GoRoute(path: '/signup', builder: (_, index) => const SignUpScreen()),
    GoRoute(path: '/home', builder: (_, index) => const HomeScreen()),
    GoRoute(path: '/addscreen', builder: (_, index) =>  AddTripScreen()),
  ],
);
