import 'package:flutter/material.dart';
import '../theme/style.dart';
import '../components/custom_text_field.dart';

class MyPageEditInfo extends StatelessWidget {
  const MyPageEditInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("계정 정보 수정"), centerTitle: true, backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Center(child: Chip(label: Text("로고", style: TextStyle(color: Colors.grey)), backgroundColor: Color(0xFFE0E0E0))),
            const SizedBox(height: 30),

            const CustomTextField(label: "아이디", hint: "user_id_01"),
            const CustomTextField(label: "비밀번호", hint: "********", isPassword: true),
            const CustomTextField(label: "이름", hint: "김구독"),
            const CustomTextField(label: "생년월일", hint: "2000-01-01"),
            const CustomTextField(label: "성별", hint: "남성"),
            const CustomTextField(label: "본인 확인 이메일 (선택)", hint: "test@email.com"),

            // 전화번호 & 인증 버튼
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("전화번호", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(decoration: InputDecoration(hintText: "010-1234-5678", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue, minimumSize: const Size(80, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      child: const Text("인증번호\n받기", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(decoration: InputDecoration(hintText: "인증번호 입력", border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14))),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: Color(0xFFDDDDDD)), minimumSize: const Size(80, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                      child: const Text("확인", style: TextStyle(fontSize: 13, color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // 확인 버튼 (임시로 뒤로가기)
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: Colors.grey), elevation: 0),
                child: const Text("확인", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}