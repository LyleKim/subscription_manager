import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return _supabase.auth.signUp(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String username,
  }) async {
    await _supabase.from('users').insert({
      'user_id': userId,
      'email': email.trim(),
      'username': username.trim(),
    });
  }
}
