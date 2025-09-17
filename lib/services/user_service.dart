import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  late Box _box;
  String _username = 'User';

  String get username => _username;

  Future<void> init() async {
    _box = Hive.box('user_data');
    // Load the username from the database when the app starts
    _username = _box.get('username', defaultValue: 'User');
  }

  void updateUsername(String newName) {
    if (newName.isNotEmpty) {
      _username = newName;
      // Save the new username to the database
      _box.put('username', newName);
      notifyListeners();
    }
  }
}
