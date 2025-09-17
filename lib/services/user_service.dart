import 'package:flutter/foundation.dart';

class UserService extends ChangeNotifier {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String _username = 'User'; // Initial username

  // Public getter for the username
  String get username => _username;

  // Method to update the username and notify all listening screens
  void updateUsername(String newName) {
    if (newName.isNotEmpty) {
      _username = newName;
      notifyListeners();
    }
  }
}
