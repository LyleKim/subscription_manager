import '../services/user_service.dart';

class UserController {
  final UserService _userService;

  UserController({UserService? userService})
      : _userService = userService ?? UserService();

  Future<String?> getUserName() async {
    final userInfo = await _userService.fetchUserInfo();
    return userInfo['username'];
  }

  Future<String?> getUserEmail() async {
    final userInfo = await _userService.fetchUserInfo();
    return userInfo['email'];
  }
}
