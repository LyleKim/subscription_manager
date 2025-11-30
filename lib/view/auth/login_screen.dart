import 'package:flutter/material.dart';
import '../theme/style.dart'; 
//import '../components/custom_text_field.dart';
import 'signup_screen.dart';
import 'find_pw_screen.dart'; // [수정됨] 새 파일 import
import '../common/main_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  void _bypassLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Text("로고", style: TextStyle(color: Colors.grey, fontSize: 20)),
                ),
              ),
              const SizedBox(height: 50),

              _buildGrayInput("이메일", _emailController),
              const SizedBox(height: 12),
              _buildGrayInput("비밀번호", _pwController, isPassword: true),

              Row(
                children: [
                  Checkbox(value: true, onChanged: (v) {}, activeColor: Colors.black),
                  const Text("로그인 상태유지", style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _bypassLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("로그인", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())),
                    child: const Text("회원가입", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("|", style: TextStyle(color: Colors.grey))),
                  
                  // [수정됨] 텍스트 및 이동 화면 변경
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FindPwScreen())),
                    child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrayInput(String hint, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFE0E0E0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildSocialButton({required String text, required Color textColor, required Color bgColor, required bool hasBorder, required Widget icon, required VoidCallback onTap}) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: hasBorder ? const BorderSide(color: Color(0xFFDDDDDD)) : BorderSide.none),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}