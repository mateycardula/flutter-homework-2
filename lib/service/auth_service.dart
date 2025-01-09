import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jokes_homework/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Secure Storage
import '../screens/auth/login_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> register(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'loggedIn', value: 'true');

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

  Future<String?> login(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'loggedIn', value: 'true');

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

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await _secureStorage.write(key: 'loggedIn', value: 'false');
      await _secureStorage.delete(key: 'email');

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

  Future<bool> isLoggedIn() async {
    String? loggedIn = await _secureStorage.read(key: 'loggedIn');
    return loggedIn == 'true';
  }

  Future<String?> getEmail() async {
    try {
      return await _secureStorage.read(key: 'email');
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
