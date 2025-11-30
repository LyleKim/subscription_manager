import '../../models/home_data.dart';
import '../services/platform_service.dart';

class HomeController {
  final PlatformService _platformService;

  HomeController({PlatformService? platformService})
      : _platformService = platformService ?? PlatformService();

  Future<HomeData> fetchHomeData({String? platformName}) async {
    try {
      final platformInfos = await _platformService.fetchPlatformsByName(platformName);

      final totalExpense = platformInfos.fold<int>(
        0,
        (sum, p) => sum + (p.paymentAmount ?? 0),
      );

      // 절약액은 임시로 0 설정
      final savingAmount = 0;

      final subscriptions = platformInfos.map<SubscriptionItem>((platformInfo) {
        final now = DateTime.now();
        String dDayText = "D-?";
        if (platformInfo.paymentDueDate != null) {
          final diffDays = platformInfo.paymentDueDate!.difference(now).inDays;
          dDayText = diffDays >= 0 ? "D-$diffDays" : "D+${-diffDays}";
        }
        return SubscriptionItem(
          platformName: platformInfo.name,
          dDayText: dDayText,
        );
      }).toList();

      return HomeData(
        totalExpense: totalExpense,
        savingAmount: savingAmount,
        subscriptions: subscriptions,
      );
    } catch (e) {
      // 예외 처리 시 빈 데이터 반환
      return HomeData(totalExpense: 0, savingAmount: 0, subscriptions: []);
    }
  }
}
