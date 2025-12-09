import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/auth/signin_screen.dart';
import '../screens/home/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return StreamBuilder(stream: _auth.authStateChanges(), builder: (_,snap){
      if(snap.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      if(snap.hasData && snap.data != null){
        return Home();
      }else{
        return SignInScreen();
      }
    });
  }
}
