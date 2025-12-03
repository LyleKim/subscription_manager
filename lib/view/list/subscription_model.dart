class SubscriptionModel {
  final String platformName;
  final String planName;
  final int price;
  final DateTime paymentDate;
  final String accountHint;
  final DateTime startDate;
  final DateTime endDate;
  final int planId;

  SubscriptionModel({
    required this.platformName,
    required this.planName,
    required this.price,
    required this.paymentDate,
    required this.accountHint,
    required this.startDate,
    required this.endDate,
    required this.planId,
  });

  // D-Day 계산
  int get dDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
    return target.difference(today).inDays;
  }

  // 수정 기능 위한 복사 함수
  SubscriptionModel copyWith({
    String? platformName,
    String? planName,
    int? price,
    DateTime? paymentDate,
    String? accountHint,
    DateTime? startDate,
    DateTime? endDate,
    int? planId, // planId도 선택적 복사 가능
  }) {
    return SubscriptionModel(
      platformName: platformName ?? this.platformName,
      planName: planName ?? this.planName,
      price: price ?? this.price,
      paymentDate: paymentDate ?? this.paymentDate,
      accountHint: accountHint ?? this.accountHint,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      planId: planId ?? this.planId,
    );
  }

  // 백엔드 연결용 factory 메서드
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      platformName: json['name'] ?? '이름 없음',
      price: json['payment_amount'] ?? 0,
      planName: json['plan_name'] ?? '기본 요금제',
      paymentDate: DateTime.parse(json['payment_due_date']),
      accountHint: json['account_hint'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      planId: json['plan_id'] ?? 0, // null 허용하지 않으므로 기본값 0 설정
    );
  }
}
