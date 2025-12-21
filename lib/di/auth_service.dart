import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import './database_service.dart';

class AuthService {
  AuthService(this._databaseService);
  late final DatabaseService _databaseService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // 1. The Source of Truth: Listen to this in your UI (StreamBuilder)
  // It triggers whenever a user signs in or out of Firebase.
  Stream<User?> get userStream => _auth.authStateChanges();

  bool get supportsAuthenticate => _googleSignIn.supportsAuthenticate();

  User? get currentUser => _auth.currentUser;

  // 2. Initialize Service
  Future<void> init() async {
    try {
      await _googleSignIn.initialize(
        clientId: null, // Handled automatically on Android
        serverClientId:
            '451047454006-7lm84kno1tn7m6h2pe2bj38bo4g045nr.apps.googleusercontent.com',
      );
      // Optional: Check if user is already "lightly" authenticated
      // Note: I've intentionally commented for this assignment
      // Since, in the login screen there's also an
      // option for admin portal
      // await _googleSignIn.attemptLightweightAuthentication();
    } catch (e) {
      debugPrint("AuthService Init Error: $e");
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google account picker
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 2. Check student status
      final isActive = await _databaseService.checkStudentStatus(
        googleUser.email,
      );

      if (isActive == null) {
        throw Exception('Student profile not found. Please contact admin.');
      } else if (isActive == false) {
        throw Exception('Your account is inactive. Please contact admin.');
      }

      // 3. Get auth tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 4. Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 5. Sign into Firebase
      return await _auth.signInWithCredential(credential);
    } on Exception catch (e) {
      debugPrint("AuthService Sign-In Error: $e");
      rethrow;
    }
  }

  // 4. Sign Out Method
  Future<void> signOut() async {
    try {
      // Sign out of the Google session (clears account picker memory)
      await _googleSignIn.signOut();

      // Sign out of the Firebase session
      await _auth.signOut();

      debugPrint("User signed out from both Google and Firebase.");
    } catch (e) {
      debugPrint("AuthService Sign-Out Error: $e");
    }
  }
}
