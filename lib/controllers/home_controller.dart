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
        
        // 날짜 계산 로직 (기존 유지)
        if (platformInfo.paymentDueDate != null) {
          final diffDays = platformInfo.paymentDueDate!.difference(now).inDays;
          dDayText = diffDays >= 0 ? "D-$diffDays" : "D+${-diffDays}";
        }
        
        // [수정됨] 모델에 추가된 필수 값(paymentDate, group)을 넣어줍니다.
        return SubscriptionItem(
          platformName: platformInfo.name,
          dDayText: dDayText,
          
          // 1. 결제일 전달 (null이면 오늘 날짜로 임시 대체)
          paymentDate: platformInfo.paymentDueDate ?? DateTime.now(),
          
          // 2. 그룹(카테고리) 정보 전달
          // PlatformInfo에 group이 있다면 그걸 쓰고, 없으면 '기타'
          group: platformInfo.group, 
        );
      }).toList();

      return HomeData(
        totalExpense: totalExpense,
        savingAmount: savingAmount,
        subscriptions: subscriptions,
      );
    } catch (e) {
      // 에러 확인을 위해 콘솔에 출력 (개발용)
      print("fetchHomeData Error: $e");
      
      // 예외 처리 시 빈 데이터 반환
      return HomeData(totalExpense: 0, savingAmount: 0, subscriptions: []);
    }
  }
}