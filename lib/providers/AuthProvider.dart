import 'package:book_room/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:book_room/services/auth_service.dart' as auth_service;

class AuthProvider with ChangeNotifier {
  final auth_service.AuthService _authService = auth_service.AuthService();
  User? _user;

  User? get user => _user;
  Stream<User?> get userStream => _authService.user;

  AuthProvider() {
    _authService.user.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<UserCredential?> signIn(String email, String password) async {
    return await _authService.signInWithEmailAndPassword(email, password);
  }

  Future<UserModel?> signUp(String email, String password) async {
    return await _authService.registerWithEmail(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}