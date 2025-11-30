//회원가입
//입력 : email:string, password:string, username:string
//리턴 : Future<SignUpResult>

import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class SignUpResult {
  final bool success;
  final String message;
  final User? user;

  SignUpResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class SignUpController {
  final AuthService _authService;

  SignUpController(this._authService);

  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final authResponse = await _authService.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;

      if (user == null) {
        return SignUpResult(
          success: false,
          message: '회원가입 실패: 사용자 데이터 없음',
        );
      }

      await _authService.createUserProfile(
        userId: user.id,
        email: email,
        username: username,
      );

      return SignUpResult(
        success: true,
        message: '회원가입 성공',
        user: user,
      );
    } catch (e) {
      return SignUpResult(
        success: false,
        message: '회원가입 실패: $e',
      );
    }
  }
}
