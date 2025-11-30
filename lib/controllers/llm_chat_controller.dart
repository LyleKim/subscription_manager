import '../services/llm_chat_service.dart';

class AIChatController {
  final AIChatService _service;

  // 기존 생성자
  AIChatController(this._service);

  // 인자 없는 기본 생성자 (named constructor)
  AIChatController.basic() : _service = AIChatService();

  Future<String> sendMessage(String prompt) async {
    final messages = [
      {'role': 'system', 'content': '친절한 말투로 5줄 정도로만 설명해야해.'},
      {'role': 'user', 'content': prompt},
    ];
    try {
      return await _service.fetchChatCompletion(messages);
    } catch (e) {
      return 'API 호출 오류: $e';
    }
  }
}
