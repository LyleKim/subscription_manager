// 비밀번호 찾기 화면

import 'package:flutter/material.dart';
import '../theme/style.dart'; 

class FindPwScreen extends StatefulWidget {
  const FindPwScreen({super.key});

  @override
  State<FindPwScreen> createState() => _FindPwScreenState();
}

class _FindPwScreenState extends State<FindPwScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("비밀번호 찾기"), // [수정됨] 타이틀 변경
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFE0E0E0),
                child: Text("로고", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
            
            // [수정됨] 이메일 입력창 하나만 남김
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "가입한 이메일 입력",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // [BACKEND] Supabase 비밀번호 재설정 이메일 발송 API 호출
                  // await Supabase.instance.client.auth.resetPasswordForEmail(_emailController.text);

                  // [수정됨] "찾은 화면" (완료 화면)으로 이동
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindPwCompleteScreen()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// [추가됨] 비밀번호 찾기 완료 화면 (피그마의 '찾은 화면')
class FindPwCompleteScreen extends StatelessWidget {
  const FindPwCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFE0E0E0),
                child: Text("로고", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "입력하신 이메일로\n비밀번호 재설정 링크를 보냈습니다.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 화면으로 돌아가기 (모든 스택 지우기)
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("로그인 화면으로 이동", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}