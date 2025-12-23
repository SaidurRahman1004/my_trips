import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  //Instance of Auth and fireStroe
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //cheak User Login Status
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      //SignUp Functions
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user; //return user when successfull login

      if (user != null) {
        //set Nome in Auth Profile
        await user.updateDisplayName(name);
        await user.reload();
        //Add user to firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'createdAt': Timestamp.now(),
        });
        return _auth.currentUser;
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
    return null;
  }

  //Login Function
  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  //Log Out Function
  Future<void> logOut() async {
    try {
      await _auth.signOut();
      print('User Logged Out successfully');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

//  GoRouter Bridge helper Class For Senting Auth State Changes(logou/login) its help GoRouter For redirect or refresh or chinging Ui with Firebase State Change
class GoRouterRefreshStream extends ChangeNotifier {
  late StreamSubscription<dynamic> _streamSubscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _streamSubscription = stream.asBroadcastStream().listen((dynamic) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
