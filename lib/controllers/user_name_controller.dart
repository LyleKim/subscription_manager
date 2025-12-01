// lib/controllers/user_name_controller.dart
import '../services/user_service.dart';

class UserNameController {
  final UserService _userService;

  UserNameController({UserService? userService})
      : _userService = userService ?? UserService();

  /// 현재 로그인된 사용자의 name을 그대로 반환
  Future<String?> loadUserName() {
    return _userService.fetchUserName();
  }
}
