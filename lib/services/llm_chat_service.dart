// llm 질의 응답
// 입력 : 질의
// 동작 : grop llm에 질의를 주고 받음
// 리턴 : 응답을 string으로 리턴

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> fetchChatCompletion(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'groq/compound',
        'messages': messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //내용만 가지고 있음
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch chat completion: ${response.statusCode}');
    }
  }
}
