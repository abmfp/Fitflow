import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  late Box _box;
  String _username = 'User';
  String? _profilePicturePath;
  String? _backgroundImagePath; // New field for the background

  String get username => _username;
  String? get profilePicturePath => _profilePicturePath;
  String? get backgroundImagePath => _backgroundImagePath; // New getter

  Future<void> init() async {
    _box = Hive.box('user_data');
    _username = _box.get('username', defaultValue: 'User');
    _profilePicturePath = _box.get('profilePicturePath');
    _backgroundImagePath = _box.get('backgroundImagePath'); // Load from database
  }

  void updateUsername(String newName) {
    if (newName.isNotEmpty) {
      _username = newName;
      _box.put('username', newName);
      notifyListeners();
    }
  }

  void updateProfilePicture(String path) {
    _profilePicturePath = path;
    _box.put('profilePicturePath', path);
    notifyListeners();
  }

  // New method to update the background image
  void updateBackgroundImage(String path) {
    _backgroundImagePath = path;
    _box.put('backgroundImagePath', path);
    notifyListeners();
  }
}
