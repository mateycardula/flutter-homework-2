import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Secure Storage
import '../screens/auth/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(); // Secure Storage instance

  // Register a new user
  Future<String?> register(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _secureStorage.write(key: 'email', value: email); // Store email securely
      await _secureStorage.write(key: 'loggedIn', value: 'true'); // Store login status securely
      // Navigate to login screen or home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }

  // Log in an existing user
  Future<String?> login(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _secureStorage.write(key: 'email', value: email); // Store email securely
      await _secureStorage.write(key: 'loggedIn', value: 'true'); // Store login status securely

      // Navigate to home screen
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }

  // Log out the current user
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await _secureStorage.write(key: 'loggedIn', value: 'false'); // Update login status securely
      await _secureStorage.delete(key: 'email'); // Delete stored email

      // Navigate back to login screen
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    } catch (e) {
      print('Error signing out: ${e.toString()}');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    String? loggedIn = await _secureStorage.read(key: 'loggedIn');
    return loggedIn == 'true'; // Check if the user is logged in
  }

  // Get the current user's email
  Future<String?> getEmail() async {
    try {
      return await _secureStorage.read(key: 'email'); // Read the stored email securely
    } catch (e) {
      print('Error retrieving email: ${e.toString()}');
      return null;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset link sent to your email.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }
}
