// 새로운 구독 등록
//입력 : 플랫폼 이름, 그룹, 플랜 이름, 결제 금액, 구독 시작일
//동작 : platforms, plans, subscribe_info 테이블 초기화
//리턴 : 성공 시 1, 실패 시 0

import '../services/platform_registration_service.dart';

class PlatformRegistrationController {
  final PlatformRegistrationService _service;

  PlatformRegistrationController({PlatformRegistrationService? service})
      : _service = service ?? PlatformRegistrationService();

  Future<int> register({
    required String name,
    required String group,
    required String planName,
    required String paymentAmountText,
    required String startDateText,
  }) async {
    try {
      if (name.isEmpty ||
          group.isEmpty ||
          planName.isEmpty ||
          paymentAmountText.isEmpty ||
          startDateText.isEmpty) {
        throw ArgumentError(
            'name, group, plan_name, payment_amount, start_date를 모두 입력하세요.');
      }

      final int? paymentAmount = int.tryParse(paymentAmountText);
      if (paymentAmount == null) {
        throw ArgumentError('payment_amount에는 숫자만 입력하세요.');
      }

      DateTime startDate;
      try {
        startDate = DateTime.parse(startDateText); // YYYY-MM-DD
      } catch (_) {
        throw ArgumentError(
            'start_date는 YYYY-MM-DD 형식으로 입력하세요. 예: 2025-11-29');
      }

      await _service.registerPlatformAndPlan(
        name: name,
        group: group,
        planName: planName,
        paymentAmount: paymentAmount,
        startDate: startDate,
      );
      
      return 1; // 성공
    } catch (e) {
      // 실패 (모든 예외 처리)
      return 0;
    }
  }
}
