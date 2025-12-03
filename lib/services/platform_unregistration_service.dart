import 'package:supabase_flutter/supabase_flutter.dart';

class PlatformUnregistrationService {
  final SupabaseClient _supabase;

  PlatformUnregistrationService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  /// 현재 로그인한 사용자의 구독 삭제
  /// 1) subscribe_info 에서 (user_id, platform_id) 삭제
  /// 2) plans 에서 (user_id, platform_id) 삭제  
  /// 3) platforms 는 삭제하지 않음 (플랫폼 정보는 유지)
  Future<String> unregisterPlatform({
    required String name,  // 또는 platformId 사용 가능
  }) async {
    // 현재 로그인한 사용자 ID 가져오기
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return '로그인된 사용자가 없습니다.';
    }
    final userId = user.id;

    // 1) platforms 에서 platform_id 조회
    final platformRow = await _supabase
        .from('platforms')
        .select('platform_id')
        .eq('name', name)
        .maybeSingle();

    if (platformRow == null) {
      return '플랫폼 "$name"이 존재하지 않습니다.';
    }

    final platformId = platformRow['platform_id'] as int;

    // 2) subscribe_info 에서 삭제 (현재 로그인한 user_id, platform_id 조건)
    final subscribeDelete = await _supabase
        .from('subscribe_info')
        .delete()
        .eq('user_id', userId)
        .eq('platform_id', platformId);

    // 3) plans 에서 삭제 (현재 로그인한 user_id, platform_id 조건)
    final plansDelete = await _supabase
        .from('plans')
        .delete()
        .eq('user_id', userId)
        .eq('platform_id', platformId);

    // 결과 메시지 반환 (platforms는 삭제하지 않음)
    return '구독 삭제 완료!\n'
        'user_id: $userId\n'
        'platform name: $name\n'
        'platform_id: $platformId\n'
        'subscribe_info 삭제: ${subscribeDelete.count ?? 0}개\n'
        'plans 삭제: ${plansDelete.count ?? 0}개\n'
        'platforms: 유지됨 (플랫폼 정보 삭제 안함)';
  }
}
