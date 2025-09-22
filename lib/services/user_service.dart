import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  late Box _box;
  String _username = 'User';
  String? _profilePicturePath;

  String get username => _username;
  String? get profilePicturePath => _profilePicturePath;

  Future<void> init() async {
    _box = Hive.box('user_data');
    _username = _box.get('username', defaultValue: 'User');
    _profilePicturePath = _box.get('profilePicturePath');
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
}
