class HomeData {
  final int totalExpense;
  final int savingAmount;
  final List<SubscriptionItem> subscriptions;

  HomeData({
    required this.totalExpense,
    required this.savingAmount,
    required this.subscriptions,
  });
}

class SubscriptionItem {
  final String platformName;
  final String dDayText;
  final DateTime paymentDate; 
  final String group; 

  SubscriptionItem({
    required this.platformName,
    required this.dDayText,
    required this.paymentDate, // 필수값
    this.group = '기타',         // 기본값
  });
}