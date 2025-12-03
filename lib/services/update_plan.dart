import 'package:supabase_flutter/supabase_flutter.dart';

class PlanService {
  final SupabaseClient _supabase;

  PlanService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  Future<bool> updatePlanById({
    required int planId,          // plans.plan_id (PK)
    required String platformName, // 필요 시 로깅/검증용
    required String planName,
    required int paymentAmount,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return false;
    }

    try {
      final response = await _supabase
          .from('plans')
          .update({
            'plan_name': planName,
            'payment_amount': paymentAmount,
          })
          .eq('plan_id', planId)
          .select(); // List<Map<String, dynamic>> 반환 [web:43]

      // 불필요한 `is List` 체크 제거
      if (response.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      // debugPrint('updatePlanById error: $e');
      return false;
    }
  }
}
