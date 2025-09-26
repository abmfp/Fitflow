import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  late Box _box;
  String _username = 'User';
  String? _profilePicturePath;
  String? _backgroundImagePath;

  String get username => _username;
  String? get profilePicturePath => _profilePicturePath;
  String? get backgroundImagePath => _backgroundImagePath;

  Future<void> init() async {
    _box = Hive.box('user_data');
    _username = _box.get('username', defaultValue: 'User');
    _profilePicturePath = _box.get('profilePicturePath');
    _backgroundImagePath = _box.get('backgroundImagePath');
  }

  Future<void> updateUsername(String newName) async {
    if (newName.isNotEmpty) {
      _username = newName;
      await _box.put('username', newName);
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String path) async {
    _profilePicturePath = path;
    await _box.put('profilePicturePath', path);
    notifyListeners();
  }

  Future<void> updateBackgroundImage(String path) async {
    _backgroundImagePath = path;
    await _box.put('backgroundImagePath', path);
    notifyListeners();
  }
}
