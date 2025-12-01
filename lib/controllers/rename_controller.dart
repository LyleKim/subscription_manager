import 'package:supabase_flutter/supabase_flutter.dart';

class RenameController {
  final SupabaseClient _supabase;

  RenameController({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  Future<bool> renameUser(String newName) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      // 로그인된 사용자가 없으면 실패 반환
      return false;
    }

    try {
      await _supabase
          .from('users')
          .update({'username': newName.trim()})
          .eq('user_id', user.id);
      return true;
    } catch (e) {
      print("Rename failed: $e");
      return false;
    }
  }
}
