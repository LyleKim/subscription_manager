import 'package:flutter/material.dart';
import '../theme/style.dart';
import '../../controllers/llm_chat_controller.dart';
import '../../controllers/platform_controller.dart';

class LLMChatScreen extends StatefulWidget {
  const LLMChatScreen({super.key});

  @override
  State<LLMChatScreen> createState() => _LLMChatScreenState();
}

class _LLMChatScreenState extends State<LLMChatScreen> {
  final _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _messages = [];
  bool _isLoading = false;

  final PlatformInfoController _platformInfoController =
      PlatformInfoController();

  Future<void> _onSend([String? textOverride]) async {
    final text = textOverride ?? _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(text);
      _isLoading = true;
      if (textOverride == null) _textController.clear();
    });
    _scrollToBottom();

    try {
      final controller = AIChatController.basic();
      final reply = await controller.sendMessage(text);
      setState(() {
        _messages.add(reply);
      });
    } catch (e) {
      setState(() {
        _messages.add('오류가 발생했습니다: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // "💸 중복 구독 찾아줘" 전용 핸들러
  Future<void> _onSendDuplicateCheck() async {
    try {
      final platforms = await _platformInfoController.getPlatformsByName(null);

      // name, paymentAmount 요약 문자열
      final summary = platforms.map((p) {
        final amount = p.paymentAmount?.toString() ?? '알 수 없음';
        return '- ${p.name}: ${amount}원';
      }).join('\n');

      final prompt = '''
내 현재 구독 목록과 월 결제 금액은 다음과 같아:

$summary

이 목록을 기반으로 "중복 구독"이 무엇인지 찾아서 설명해줘.
각 중복 구독 쌍과, 그로 인한 월 지출 총액을 함께 알려줘.
''';

      await _onSend(prompt);
    } catch (e) {
      setState(() {
        _messages.add('구독 정보를 불러오는 중 오류가 발생했습니다: $e');
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "AI_Chat",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return _buildMessageBubble(
                        index.isEven,
                        msg,
                      ); // 짝수는 user, 홀수는 AI
                    },
                  ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.smart_toy, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue
                          .withAlpha((0.3 * 255).round()),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "궁금한 내용을 물어보세요...",
                        filled: true,
                        fillColor: const Color(0xFFF5F6F8),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _onSend(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor:
                        _isLoading ? Colors.grey : AppColor.primaryBlue,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white, size: 18),
                      onPressed: _isLoading ? null : () => _onSend(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.smart_toy, size: 18, color: Colors.grey),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColor.primaryBlue : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 50,
            color: AppColor.primaryBlue.withAlpha((0.3 * 255).round()),
          ),
          const SizedBox(height: 20),
          const Text(
            "무엇을 도와드릴까요?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip("💸 중복 구독 찾아줘", isDuplicateCheck: true),
              _buildChip("📊 2030세대가 많이 구독하는 플랫폼에는 뭐가 있어?"),
              _buildChip("💰 넷플릭스 싸게 보는 법"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String text, {bool isDuplicateCheck = false}) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 13)),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFEEEEEE)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        if (isDuplicateCheck) {
          _onSendDuplicateCheck();
        } else {
          _onSend(text);
        }
      },
    );
  }
}
