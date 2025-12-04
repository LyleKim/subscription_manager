// lib/view/list/subscription_model.dart

class SubscriptionModel {
  final String platformName;
  final int price;
  final String planName;
  final DateTime paymentDate;
  final DateTime startDate;
  final DateTime endDate;
  final String accountHint;
  final int planId;
  final String group; // [추가됨] 상세 화면에서 아이콘 보여줄 때 필요!

  SubscriptionModel({
    required this.platformName,
    required this.price,
    required this.planName,
    required this.paymentDate,
    required this.startDate,
    required this.endDate,
    required this.accountHint,
    required this.planId,
    required this.group, // [추가됨] 필수값
  });

  // [추가됨] copyWith 메서드 (수정 시 데이터 갱신을 쉽게 하기 위함)
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