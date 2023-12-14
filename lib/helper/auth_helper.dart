import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../modals/user_modal.dart';

class AuthHelper {
  AuthHelper._();
  static final AuthHelper authHelper = AuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Logger logger = Logger();

  Future<void> signInAnounimously() async {
    await firebaseAuth.signInAnonymously();
  }

  Future<User?> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    try {
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication!.idToken,
            accessToken: googleSignInAuthentication.accessToken),
      );
      logger.i("Succes...!!");
      return userCredential.user;
    } catch (e) {
      logger.i("ERROR : $e");
      return null;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User?> registerUserWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ERROR: ${e.code.toString()}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    return userCredential?.user;
  }

  Future<User?> signInWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    print("Email : $email , password : $password");
    UserCredential? userCredential;

    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ERROR : ${e.code.toString()}"),
        ),
      );
    }
    return userCredential?.user;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
