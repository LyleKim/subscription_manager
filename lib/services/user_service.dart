import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('UserService');

class UserService {
  final SupabaseClient _supabase;

  UserService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  Future<String?> fetchUserName() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _logger.warning('fetchUserName: currentUser is null');
      return null;
    }

    try {
      final data = await _supabase
          .from('users')
          .select('username')
          .eq('user_id', user.id)
          .single(); // Map<String, dynamic>[web:32]

      _logger.info('fetchUserName data: $data');

      final name = data['username'] as String?;
      if (name == null || name.isEmpty) {
        _logger.warning('fetchUserName: name is null or empty for user_id=${user.id}');
      }
      return name;
    } catch (e, stackTrace) {
      _logger.severe('User fetch error', e, stackTrace);
      return null;
    }
  }
}
