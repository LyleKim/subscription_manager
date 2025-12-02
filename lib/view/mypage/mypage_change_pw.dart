// 비밀번호 변경 화면

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/style.dart';

class MyPageChangePw extends StatefulWidget {
  const MyPageChangePw({super.key});

  @override
  State<MyPageChangePw> createState() => _MyPageChangePwState();
}

class _MyPageChangePwState extends State<MyPageChangePw> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  
  // UI 상태 관리용 변수
  bool _isCurrentPwMatch = false; // 현재 비번이 맞는지?
  bool _showErrorMsg = false;     // 에러 메시지를 보여줄지?

  // [BACKEND] 현재 비밀번호 확인 로직 (임시)
  void _checkCurrentPassword(String input) async {
    // 실제로는 여기서 DB 검증을 하거나, Supabase re-authenticate 기능을 써야 함.
    // 지금은 데모용으로 '1234' 라고 치면 맞는 걸로 처리.
    // 현재 기능구현 완료
    final SupabaseClient _supabase = Supabase.instance.client;

    try
    {
      final res = await _supabase.auth.signInWithPassword(//input을 pw로 재로그인 시도
        email : _supabase.auth.currentUser!.email,
        password: input 
      );
    } catch(e){
      setState(() {
      _isCurrentPwMatch = false;//불일치시 이 코드 실행, 새 pw입력창 비활성화
      _showErrorMsg = true;
      });

      return;
    }

    setState(() {
      _isCurrentPwMatch = true;//일치시 이 코드 실행, 새 pw입력창 비활성화     
      _showErrorMsg = false;     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("비밀번호 변경"), centerTitle: true, backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Center(child: Chip(label: Text("LOGO", style: TextStyle(color: Colors.grey)), backgroundColor: Color(0xFFE0E0E0))),
            const SizedBox(height: 40),

            // 1. 현재 비밀번호 입력
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _currentPwController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "현재 비밀번호",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _checkCurrentPassword(_currentPwController.text),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFDDDDDD)), minimumSize: const Size(60, 50)),
                  child: const Text("확인", style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
              ],
            ),
            
            // 일치/불일치 메시지
            if (_isCurrentPwMatch)
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: Align(alignment: Alignment.centerLeft, child: Text("비밀번호가 일치합니다.", style: TextStyle(color: Colors.blue, fontSize: 12))),
              ),
            if (_showErrorMsg && !_isCurrentPwMatch)
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: Align(alignment: Alignment.centerLeft, child: Text("비밀번호가 일치하지 않습니다.", style: TextStyle(color: Colors.red, fontSize: 12))),
              ),

            const SizedBox(height: 20),

            // 2. 새 비밀번호 입력 (현재 비번 확인 안 되면 비활성화)
            TextField(
              controller: _newPwController,
              enabled: _isCurrentPwMatch, // 여기가 핵심! 확인 전엔 입력 불가
              obscureText: true,
              decoration: InputDecoration(
                hintText: "새 비밀번호 입력(6자리이상)",
                filled: !_isCurrentPwMatch,
                fillColor: _isCurrentPwMatch ? Colors.white : Colors.grey[200],
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isCurrentPwMatch ? () async {
                  // [BACKEND] 여기서 Supabase 비밀번호 변경 API 호출
                  await Supabase.instance.client.auth.updateUser(UserAttributes(password: _newPwController.text));
                  
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("비밀번호가 변경되었습니다.")));
                  Navigator.pop(context);
                } : null, // 확인 안 되면 버튼도 비활성화
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue, 
                  disabledBackgroundColor: Colors.grey, // 비활성화 색상
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: const Text("비밀번호 변경", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}