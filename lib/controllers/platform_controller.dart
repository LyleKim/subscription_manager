//다음 결제 예정일, 결제 금액을 가져온다.
//입력 : 플랫폼 이름(이것만 가져온다.) or null(전부 다 가져온다.)
//동작 : 현재 로그인 되어 있는 user_id를 가지고 구독 중인 플랫폼의 
//payment_due_date, payment_amout를 가져온다.
//리턴 : PlatformInfo 구조체 리턴(id, name, paymentduedate, paymentamount, plan_name)

import '../services/platform_service.dart';

class PlatformInfoController {
  final PlatformService _platformService;

  PlatformInfoController({PlatformService? platformService})
      : _platformService = platformService ?? PlatformService();

  // name이 null이면 전체, name이 있으면 해당 플랫폼들만(id, name, 다음 결제일, 금액) 가져오기
  Future<List<PlatformInfo>> getPlatformsByName(String? name) {
    return _platformService.fetchPlatformsByName(name);
  }
}
