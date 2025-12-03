import '../services/platform_unregistration_service.dart';

class PlatformUnregistrationController {
  final PlatformUnregistrationService _unregistrationService;

  PlatformUnregistrationController({PlatformUnregistrationService? service})
      : _unregistrationService = service ?? PlatformUnregistrationService();

  Future<int> cancelPlatformSubscription({
    required String platformName,
  }) async {
    try {
      final result = await _unregistrationService.unregisterPlatform(
        name: platformName,
      );
      
      // Service가 delete row 수 반환하도록 가정하고 직접 int 반환
      final deleteCount = int.tryParse(result) ?? 0;
      return deleteCount; // 1=성공, 0=실패
    } catch (e) {
      return 0;
    }
  }
}
