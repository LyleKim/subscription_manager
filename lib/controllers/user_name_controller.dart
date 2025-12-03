import '../services/user_service.dart';

class UserNameController {
  final UserService _userService;

  UserNameController({UserService? userService})
      : _userService = userService ?? UserService();

  /// 현재 로그인된 사용자의 username을 반환
  Future<String?> loadUserName() async {
    final userInfo = await _userService.fetchUserInfo();
    return userInfo['username'];
  }
}
