import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_trips/Core/routs.dart';
import 'package:my_trips/screens/auth/sign_up_screen.dart';
import 'package:my_trips/screens/auth/signin_screen.dart';
import 'package:my_trips/services/auth_wraper.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}



