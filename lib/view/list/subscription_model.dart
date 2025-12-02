// lib/view/list/subscription_model.dart

class SubscriptionModel {
  final String platformName;
  final String planName;
  final int price;
  final DateTime paymentDate;
  final String accountHint;
  final DateTime startDate;
  final DateTime endDate;

  SubscriptionModel({
    required this.platformName,
    required this.planName,
    required this.price,
    required this.paymentDate,
    required this.accountHint,
    required this.startDate,
    required this.endDate,
  });

  // D-Day 계산
  int get dDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
    return target.difference(today).inDays;
  }

  // ✅ [NEW] 수정 기능을 위한 복사 함수
  // 예: copyWith(price: 20000) -> 가격만 20000원으로 바뀐 새 객체 생성
  SubscriptionModel copyWith({
    String? platformName,
    String? planName,
    int? price,
    DateTime? paymentDate,
    String? accountHint,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return SubscriptionModel(
      platformName: platformName ?? this.platformName,
      planName: planName ?? this.planName,
      price: price ?? this.price,
      paymentDate: paymentDate ?? this.paymentDate,
      accountHint: accountHint ?? this.accountHint,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
  
  // 백엔드 연결용
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      platformName: json['name'] ?? '이름 없음',
      price: json['payment_amount'] ?? 0,
      planName: json['plan_name'] ?? '기본 요금제',
      paymentDate: DateTime.parse(json['payment_due_date']),
      accountHint: json['account_hint'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}

// ✅ [중요] 전역 변수로 선언하여 앱이 켜져있는 동안은 수정/삭제가 공유됨
// 앱을 새로고침(Restart)하면 다시 이 초기값으로 돌아옵니다.
List<SubscriptionModel> dummySubscriptions = [
  SubscriptionModel(
    platformName: "Netflix",
    planName: "Standard",
    price: 17000,
    paymentDate: DateTime.now().add(const Duration(days: 3)),
    accountHint: "thfl4204@naver.com",
    startDate: DateTime(2023, 11, 15),
    endDate: DateTime(2025, 12, 15),
  ),
  SubscriptionModel(
    platformName: "Spotify",
    planName: "Duo",
    price: 11900,
    paymentDate: DateTime.now().add(const Duration(days: 8)),
    accountHint: "music_lover@gmail.com",
    startDate: DateTime(2024, 1, 1),
    endDate: DateTime(2025, 1, 1),
  ),
  SubscriptionModel(
    platformName: "Chat GPT",
    planName: "GPT - 4",
    price: 29000,
    paymentDate: DateTime.now().add(const Duration(days: 13)),
    accountHint: "ai_master@kakao.com",
    startDate: DateTime(2024, 5, 5),
    endDate: DateTime(2025, 5, 5),
  ),
];