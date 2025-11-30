// 새로운 구독 등록
//입력 : 플랫폼 이름, 그룹, 플랜 이름, 결제 금액, 구독 시작일
//동작 : platforms, plans, subscribe_info 테이블 초기화
//리턴 : 등록된 내용을 string으로 리턴

import 'package:supabase_flutter/supabase_flutter.dart';

class PlatformRegistrationService {
  final SupabaseClient _supabase;
  static const String fixedUserId = '9634de49-aa9f-4235-a1c6-68b5eb15adfd';

  PlatformRegistrationService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  /// 1) platforms 에 name이 있으면 그 platform_id 사용
  /// 2) 없으면 platforms 에 (name, group) insert 후 platform_id 획득
  /// 3) plans 에 (user_id, platform_id, plan_name, payment_amount) insert
  /// 4) subscribe_info 에 (user_id, platform_id, start_date) insert
  Future<String> registerPlatformAndPlan({
    required String name,
    required String group,
    required String planName,
    required int paymentAmount,
    required DateTime startDate,
  }) async {
    // 1) platforms 에 name 존재 여부 확인
    final existing = await _supabase
        .from('platforms')
        .select('platform_id, name, "group"')
        .eq('name', name)
        .maybeSingle();

    int platformId;

    if (existing != null) {
      platformId = existing['platform_id'] as int;
    } else {
      // 2) 없으면 platforms 에 insert 후 platform_id 받기
      final insertResult = await _supabase
          .from('platforms')
          .insert({
            'name': name,
            'group': group,
          })
          .select('platform_id')
          .single();

      platformId = insertResult['platform_id'] as int;
    }

    // 3) plans 에 insert
    await _supabase.from('plans').insert({
      'user_id': fixedUserId,
      'platform_id': platformId,
      'plan_name': planName,
      'payment_amount': paymentAmount,
    });

    // 4) subscribe_info 에 insert
    await _supabase.from('subscribe_info').insert({
      'user_id': fixedUserId,
      'platform_id': platformId,
      'start_date': startDate.toIso8601String(),
    });

    // 결과 메시지는 컨트롤러/뷰에서 바로 보여줄 수 있게 문자열로 반환
    return '플랫폼, 플랜, 구독 정보 등록 완료!\n'
        'platform name: $name\n'
        'group: $group\n'
        'platform_id: $platformId\n'
        'plan_name: $planName\n'
        'payment_amount: $paymentAmount\n'
        'start_date: ${startDate.toIso8601String()}';
  }
}
