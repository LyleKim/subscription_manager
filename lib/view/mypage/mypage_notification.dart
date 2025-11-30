import 'package:flutter/material.dart';
import '../theme/style.dart';

class MyPageNotification extends StatefulWidget {
  const MyPageNotification({super.key});

  @override
  State<MyPageNotification> createState() => _MyPageNotificationState();
}

class _MyPageNotificationState extends State<MyPageNotification> {
  // 스위치 상태 변수들
  bool _isPaymentAlert = true;
  bool _isRecAlert = true;
  bool _isSubAlert1 = true;
  bool _isSubAlert2 = true;
  bool _isSubAlert3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("알림 On/Off"), centerTitle: true, backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Center(child: Chip(label: Text("로고", style: TextStyle(color: Colors.grey)), backgroundColor: Color(0xFFE0E0E0))),
            const SizedBox(height: 40),

            _buildSwitchTile("결제 3일전 알림", _isPaymentAlert, (v) => setState(() => _isPaymentAlert = v)),
            _buildSwitchTile("구독 추천 알림", _isRecAlert, (v) => setState(() => _isRecAlert = v)),
            _buildSwitchTile("구독 추천 알림", _isSubAlert1, (v) => setState(() => _isSubAlert1 = v)),
            _buildSwitchTile("구독 추천 알림", _isSubAlert2, (v) => setState(() => _isSubAlert2 = v)),
            _buildSwitchTile("구독 추천 알림", _isSubAlert3, (v) => setState(() => _isSubAlert3 = v)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColor.primaryBlue,
        activeTrackColor: AppColor.primaryBlue.withOpacity(0.5),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}