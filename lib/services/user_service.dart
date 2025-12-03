import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('UserService');

class UserService {
  final SupabaseClient _supabase;

  UserService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  Future<Map<String, String?>> fetchUserInfo() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _logger.warning('fetchUserInfo: currentUser is null');
      return {'username': null, 'email': null};
    }

    try {
      final data = await _supabase
          .from('users')
          .select('username, email')
          .eq('user_id', user.id)
          .single();

      _logger.info('fetchUserInfo data: $data');

      final username = data['username'] as String?;
      final email = data['email'] as String?;

      if (username == null || username.isEmpty) {
        _logger.warning('fetchUserInfo: username is null or empty for user_id=${user.id}');
      }
      if (email == null || email.isEmpty) {
        _logger.warning('fetchUserInfo: email is null or empty for user_id=${user.id}');
      }

      return {'username': username, 'email': email};
    } catch (e, stackTrace) {
      _logger.severe('User fetch error', e, stackTrace);
      return {'username': null, 'email': null};
    }
  }
}
