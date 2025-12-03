import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionCancelController {
  final SupabaseClient _supabase;

  SubscriptionCancelController({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  /// 구독 취소: subscribe_info의 end_date를 현재 시간으로 업데이트
  /// user_id는 현재 로그인 유저, platform_id는 전달받아 사용
  Future<bool> cancelSubscription({
    required int platformId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return false;
    }
    final userId = user.id;
    final now = DateTime.now();

    final response = await _supabase
        .from('subscribe_info')
        .update({'end_date': now.toIso8601String()})
        .eq('user_id', userId)
        .eq('platform_id', platformId);

    // 성공시 response는 업데이트된 개체들의 리스트로 올 것임
    return !(response == null || (response is List && response.isEmpty));
  }
}
