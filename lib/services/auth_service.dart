import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custo_snk.dart';

class AuthService {
  //Instance of Auth and fireStroe
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //cheak User Login Status
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword({
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
        //Add user to firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'createdAt': Timestamp.now(),
        });
        return user;
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
    } on FirebaseException catch (e) {}
  }

  //Log Out Function
  Future<void> logOut() async {
    await _auth.signOut();
  }
}
