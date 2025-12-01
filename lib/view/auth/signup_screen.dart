import 'package:flutter/material.dart';
import '../theme/style.dart'; 
import '../components/custom_text_field.dart';
import '../../services/auth_service.dart';
import '../../controllers/signup_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _nameController = TextEditingController();

  late final SignUpController _signUpController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(Supabase.instance.client);
    _signUpController = SignUpController(authService);
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _pwController.text;
    final username = _nameController.text.trim();

    final result = await _signUpController.signUp(
      email: email,
      password: password,
      username: username,
    );

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      // 회원가입 성공 시 로그인 화면으로 돌아가기
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = result.message;
      });
    }
  }

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

            CustomTextField(label: "이메일 (아이디)", hint: "example@email.com", controller: _emailController),
            CustomTextField(label: "비밀번호", hint: "비밀번호 입력", isPassword: true, controller: _pwController),
            CustomTextField(label: "이름", hint: "사용자 이름 입력", controller: _nameController),

            const SizedBox(height: 20),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("회원가입 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
