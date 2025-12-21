import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../di/auth_service.dart';

class GoogleAuthViewModel with ChangeNotifier {
  late final AuthService _authService;

  GoogleAuthViewModel(this._authService);

  User? get currentUser => _authService.currentUser;

  Stream<User?> get userStream => _authService.userStream;

  bool get supportsAuthenticate => _authService.supportsAuthenticate;

  Future<void> signInInit() async {
    try {
      await _authService.init();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signIn() async {
    try {
      await _authService.signInWithGoogle();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (_) {
      rethrow;
    }
  }
}
