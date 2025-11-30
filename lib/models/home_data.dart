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

  SubscriptionItem({
    required this.platformName,
    required this.dDayText,
  });
}
