import 'package:go_router/go_router.dart';
import 'package:my_trips/models/trip_model.dart';
import 'package:my_trips/screens/notification_screen.dart';
import 'package:my_trips/services/auth_wraper.dart';
import '../screens/add_trip/add_trip_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/signin_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/trip_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/', builder: (_, state) => const AuthWrapper()),
    GoRoute(path: '/login', builder: (_, state) => const SignInScreen()),
    GoRoute(path: '/signup', builder: (_, state) => const SignUpScreen()),
    GoRoute(path: '/home', builder: (_, state) => const HomeScreen()),
    GoRoute(path: '/addscreen', builder: (_, state) =>  AddTripScreen()),
    GoRoute(path: '/details', builder: (_, state){
      final trip = state.extra as TripModel;
      return TripDetailScreen(trip: trip);
    }),
    GoRoute(path: '/profile',builder: (_,index)=>ProfileScreen()),
    GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(path: '/massege',builder: (_,state)=>NotificationScreen()),
  ],
);
