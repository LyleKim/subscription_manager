// 회원가입 화면

import 'package:flutter/material.dart';
import '../theme/style.dart'; 
import '../components/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // [BACKEND] 회원가입 시 보낼 데이터 컨트롤러들
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("회원가입"), centerTitle: true, backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFE0E0E0),
                child: Text("Logo", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),

            // [수정됨] 아이디 입력창 삭제 -> 이메일이 아이디 역할
            CustomTextField(label: "이메일 (아이디)", hint: "example@email.com", controller: _emailController),
            CustomTextField(label: "비밀번호", hint: "비밀번호 입력", isPassword: true, controller: _pwController),
            CustomTextField(label: "이름", hint: "사용자 이름 입력", controller: _nameController),
            
            const SizedBox(height: 40),

            // 회원가입 완료 버튼
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // [BACKEND] 여기서 Supabase signUp 함수 호출
                  // email: _emailController.text
                  // password: _pwController.text
                  // data: { 'full_name': _nameController.text } 
                  
                  // 성공 시 로그인 화면으로 이동
                  Navigator.pop(context); 
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text("회원가입 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}