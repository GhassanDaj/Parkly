// services/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      notifyListeners();
    });
  }

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper method to create or update the user document in Firestore
  Future<void> _createOrUpdateUserDocument(User user, String role) async {
    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

    await userDoc.set({
      'userId': user.uid,
      'email': user.email,
      'role': role, // Role should be passed, either 'customer' or 'renter'
      'username': user.displayName ?? '',
      'phoneNumber': user.phoneNumber ?? '',
      'address': {
        'street': '',
        'city': '',
        'state': '',
        'postalCode': '',
        'country': ''
      },
      'profilePictureUrl': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'preferences': {
        'notifications': true,
        'language': 'en',
      },
      'verified': user.emailVerified,
      'rating': 0,
      'bio': '',
    }, SetOptions(merge: true));
  }

  // Sign Up with Email and Password
  Future<String?> signUp(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? newUser = result.user;
      if (newUser != null) {
        await _createOrUpdateUserDocument(newUser, role);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign In with Email and Password
  Future<String?> signIn(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? loggedInUser = result.user;
      if (loggedInUser != null) {
        await _createOrUpdateUserDocument(loggedInUser, role);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Reset Password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Sign In with Google
  Future<String?> signInWithGoogle(String role) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return 'Google Sign-In was cancelled by the user.';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential result = await _auth.signInWithCredential(credential);
      User? googleUserAuth = result.user;

      if (googleUserAuth != null) {
        await _createOrUpdateUserDocument(googleUserAuth, role);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
