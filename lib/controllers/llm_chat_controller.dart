import '../services/llm_chat_service.dart';

class AIChatController {
  final AIChatService _service;
  final List<Map<String, String>> _messageHistory = [];

  AIChatController.basic() : _service = AIChatService();

  Future<String> sendMessage(String prompt) async {
    // 히스토리 + 새 메시지
    final messages = [
      {'role': 'system', 'content': '친절한 말투로 5줄 정도로만 설명해야해. 텍스트로만 설명해줘.'},
      ..._messageHistory,
      {'role': 'user', 'content': prompt},
    ];

    try {
      final reply = await _service.fetchChatCompletion(messages);
      // 히스토리에 사용자+AI 추가
      _messageHistory.add({'role': 'user', 'content': prompt});
      _messageHistory.add({'role': 'assistant', 'content': reply});
      return reply;
    } catch (e) {
      return 'AI 서비스 이용이 일시적으로 어려워요. 잠시 후 다시 시도해주세요.';
    }
  }
}
