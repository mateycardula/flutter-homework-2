import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reference to the favorites collection
  CollectionReference get _favoritesCollection =>
      _firestore.collection('favorites');

  // Add or remove a joke to/from favorites
  Future<void> toggleFavorite(String jokeId, bool isFavorite) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-logged-in', message: 'User is not logged in');
      }

      // Add or remove the joke from Firestore based on the `isFavorite` flag
      if (isFavorite) {
        // If it's a favorite, remove it
        await _favoritesCollection
            .doc(user.uid)
            .collection('userFavorites')
            .doc(jokeId)
            .delete();
      } else {
        // If it's not a favorite, add it
        await _favoritesCollection
            .doc(user.uid)
            .collection('userFavorites')
            .doc(jokeId)
            .set({
          'jokeId': jokeId,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error toggling favorite: ${e.toString()}');
      rethrow;
    }
  }

  // Fetch all favorite jokes for the current user
  Future<List<String>> getFavoriteJokes() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-logged-in', message: 'User is not logged in');
      }

      final snapshot = await _favoritesCollection
          .doc(user.uid)
          .collection('userFavorites')
          .get();

      return snapshot.docs.map((doc) => doc['jokeId'] as String).toList();
    } catch (e) {
      print('Error fetching favorite jokes: ${e.toString()}');
      return [];
    }
  }

  // Check if a specific joke is favorited by the current user
  Future<bool> isFavorite(String jokeId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-logged-in', message: 'User is not logged in');
      }

      final doc = await _favoritesCollection
          .doc(user.uid)
          .collection('userFavorites')
          .doc(jokeId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking if joke is favorite: ${e.toString()}');
      return false;
    }
  }
}
