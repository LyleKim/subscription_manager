// lib/view/list/subscription_model.dart

class SubscriptionModel {
  // Response JSON 구조 (DB 컬럼 매핑 필요)
  final String platformName; // 서비스명
  final int price;           // 월 결제액
  final String planName;     // 요금제명 (Premium, Basic 등)
  final DateTime paymentDate;// 다음 결제일
  final DateTime startDate;  // 구독 시작일
  final DateTime endDate;    // 구독 종료일 (해지 시)
  final String accountHint;  // 연결된 계정 정보
  final int planId;          // PK (수정/삭제용)
  final String group;        // 카테고리 (OTT, Shopping 등 - 아이콘 매핑용)

  SubscriptionModel({
    required this.platformName,
    required this.price,
    required this.planName,
    required this.paymentDate,
    required this.startDate,
    required this.endDate,
    required this.accountHint,
    required this.planId,
    required this.group, 
  });

  // copyWith 메서드 (수정 시 데이터 갱신을 쉽게 하기 위함)
  SubscriptionModel copyWith({
    String? platformName,
    int? price,
    String? planName,
    DateTime? paymentDate,
    DateTime? startDate,
    DateTime? endDate,
    String? accountHint,
    int? planId,
    String? group,
  }) {
    return SubscriptionModel(
      platformName: platformName ?? this.platformName,
      price: price ?? this.price,
      planName: planName ?? this.planName,
      paymentDate: paymentDate ?? this.paymentDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      accountHint: accountHint ?? this.accountHint,
      planId: planId ?? this.planId,
      group: group ?? this.group,
    );
  }
}