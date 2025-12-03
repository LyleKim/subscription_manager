import '../services/update_plan.dart';

class PlanController {
  final PlanService _planService;

  PlanController({PlanService? planService})
      : _planService = planService ?? PlanService();

  /// 플랫폼 이름, 요금제 이름, 결제 금액, planId를 받아 plans 테이블을 업데이트
  Future<bool> savePlan({
    required int planId,
    required String platformName,
    required String planName,
    required int paymentAmount,
  }) async {
    return await _planService.updatePlanById(
      planId: planId,
      platformName: platformName,
      planName: planName,
      paymentAmount: paymentAmount,
    );
  }
}
