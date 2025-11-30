//로그인 담당
//입력 : email: sring, password:String
//리턴 : Future<LoginResult>

import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class LoginResult {
  final bool success;
  final String message;
  final User? user;

  LoginResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class LoginController {
  final AuthService _authService;

  LoginController(this._authService);

  Future<LoginResult> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        return LoginResult(
          success: false,
          message: '로그인 실패: 사용자 없음',
        );
      }

      return LoginResult(
        success: true,
        message: '로그인 성공',
        user: user,
      );
    } catch (e) {
      return LoginResult(
        success: false,
        message: '로그인 실패: $e',
      );
    }
  }
}
