import 'package:flutter/material.dart';
import '../theme/style.dart'; 
import 'signup_screen.dart';
import '../common/main_nav_screen.dart';
import '../../services/auth_service.dart';
import '../../controllers/login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/mono_logo.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  late final LoginController _loginController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final authService = AuthService(Supabase.instance.client);
    _loginController = LoginController(authService);
  }

  void _login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _pwController.text;
    // 로그인 API 요청 (email, password)
    final result = await _loginController.logIn(email: email, password: password);

    if (result.success && result.user != null) {
      if (!mounted) return;
      // 로그인 성공 시 토큰/세션 처리 확인 필요
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavScreen()),
      );
    } else {
      if (!mounted) return;
      setState(() {
        // 서버 리턴 에러 메시지 표시
        _errorMessage = result.message;
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. 로고 및 타이틀
                Column(
                  children: [
                    const MonoLogo(isSmall: false),
                    
                    const SizedBox(height: 16), // 로고와 설명 사이 간격

                    const Text(
                      "여러 구독을 하나로.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey, 
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),

                // 2. 입력 필드
                _buildModernInput("이메일", _emailController, Icons.email_outlined),
                const SizedBox(height: 16),
                _buildModernInput("비밀번호", _pwController, Icons.lock_outline, isPassword: true),

                const SizedBox(height: 24),

                // 3. 에러 메시지
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),

                // 4. 로그인 버튼
                SizedBox(
                  height: 56, 
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24, 
                            width: 24, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                          )
                        : const Text(
                            "로그인", 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                  ),
                ),
                
                const SizedBox(height: 32),

                // 5. 하단 회원가입 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("계정이 없으신가요? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: const Text(
                        "회원가입",
                        style: TextStyle(
                          color: AppColor.primaryBlue, 
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 입력창 위젯
  Widget _buildModernInput(
    String hint, 
    TextEditingController controller, 
    IconData icon, 
    {bool isPassword = false}
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 22),
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}