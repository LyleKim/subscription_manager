import 'package:flutter/material.dart';
import '../theme/style.dart'; 
import '../components/custom_text_field.dart';
import '../../services/auth_service.dart';
import '../../controllers/signup_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/mono_logo.dart'; 

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
      appBar: AppBar(
        title: const Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const MonoLogo(isSmall: true), 
            const SizedBox(height: 40),

            CustomTextField(label: "이메일 (아이디)", hint: "example@email.com", controller: _emailController),
            CustomTextField(label: "비밀번호", hint: "6자 이상 입력해주세요", isPassword: true, controller: _pwController),
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

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("가입 완료", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}