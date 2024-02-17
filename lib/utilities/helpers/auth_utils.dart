import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

class AuthUtils {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  Stream<User?> get userStream =>
      FirebaseAuth.instance.authStateChanges();
  // Create a private constructor
  AuthUtils._privateConstructor() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
    });
  }

  // Singleton approach
  static final AuthUtils _instance = AuthUtils._privateConstructor();

  factory AuthUtils() {
    return _instance;
  }

  // Method to get the current user
  User? get currentUser => _user;

  // Method to get the current user's ID
  String? get currentUserId => _user?.uid;

  // Method to check if the user is logged in
  bool isLoggedIn() => _user != null;

  // Method to handle actions that require authentication
  void handleAuthenticatedAction(BuildContext context, Function action) {
    if (isLoggedIn()) {
      action();
    } else {
      Go.to(context, Pager.login); // Navigate to the login page
    }
  }
}
