import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // [필수] Supabase 패키지
import '../theme/style.dart';
import '../components/mono_logo.dart'; 

class MyPageChangePw extends StatefulWidget {
  const MyPageChangePw({super.key});

  @override
  State<MyPageChangePw> createState() => _MyPageChangePwState();
}

class _MyPageChangePwState extends State<MyPageChangePw> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  
  // UI 상태 관리용 변수
  bool _isCurrentPwMatch = false; // 현재 비번 인증 성공 여부
  bool _showErrorMsg = false;     // 비번 틀림 메시지 표시 여부
  bool _isLoading = false;        // 로딩 상태

  // 1. 현재 비밀번호 확인 로직 (재로그인 시도)
  Future<void> _checkCurrentPassword() async {
    final inputPw = _currentPwController.text.trim();
    if (inputPw.isEmpty) return;

    setState(() {
      _isLoading = true;
      _showErrorMsg = false;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null || user.email == null) {
        throw const AuthException("로그인 정보가 없습니다.");
      }

      // 현재 이메일과 입력한 비밀번호로 로그인 시도 (검증용)
      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: inputPw,
      );

      // 예외가 발생하지 않으면 성공
      if (mounted) {
        setState(() {
          _isCurrentPwMatch = true;
          _showErrorMsg = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("확인되었습니다. 새 비밀번호를 입력해주세요.")),
        );
      }
    } on AuthException catch (e) {
      // 로그인 실패 = 비밀번호 틀림
      if (mounted) {
        setState(() {
          _isCurrentPwMatch = false;
          _showErrorMsg = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 2. 새 비밀번호로 변경 로직
  Future<void> _updatePassword() async {
    final newPw = _newPwController.text.trim();
    if (newPw.isEmpty) return;
    if (newPw.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("비밀번호는 6자 이상이어야 합니다.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 비밀번호 업데이트 요청
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPw),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("비밀번호가 성공적으로 변경되었습니다."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // 화면 닫기
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("변경 실패: ${e.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("알 수 없는 오류가 발생했습니다.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("비밀번호 변경"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const MonoLogo(isSmall: true),
            const SizedBox(height: 40),

            // 1. 현재 비밀번호 입력
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _currentPwController,
                    obscureText: true,
                    // 인증 성공하면 수정 못하게 막기
                    enabled: !_isCurrentPwMatch, 
                    decoration: InputDecoration(
                      hintText: "현재 비밀번호",
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      fillColor: _isCurrentPwMatch ? Colors.grey[200] : Colors.white,
                      filled: _isCurrentPwMatch,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // 확인 버튼 (이미 인증됐으면 체크 아이콘으로 변경)
                _isCurrentPwMatch 
                ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
                : ElevatedButton(
                    onPressed: _isLoading ? null : _checkCurrentPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, 
                      side: const BorderSide(color: Color(0xFFDDDDDD)), 
                      minimumSize: const Size(60, 50)
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("확인", style: TextStyle(fontSize: 12, color: Colors.black)),
                  ),
              ],
            ),
            
            // 일치/불일치 메시지
            if (_showErrorMsg && !_isCurrentPwMatch)
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: Align(
                  alignment: Alignment.centerLeft, 
                  child: Text("현재 비밀번호가 일치하지 않습니다.", style: TextStyle(color: Colors.red, fontSize: 12))
                ),
              ),

            const SizedBox(height: 20),

            // 2. 새 비밀번호 입력 (현재 비번 확인 안 되면 비활성화)
            TextField(
              controller: _newPwController,
              enabled: _isCurrentPwMatch, // 인증 성공 시에만 활성화
              obscureText: true,
              decoration: InputDecoration(
                hintText: "새 비밀번호 입력 (6자 이상)",
                filled: !_isCurrentPwMatch,
                fillColor: _isCurrentPwMatch ? Colors.white : Colors.grey[200],
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            const SizedBox(height: 40),
            
            // 3. 변경 버튼
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: (_isCurrentPwMatch && !_isLoading) 
                    ? _updatePassword 
                    : null, // 인증 안됐거나 로딩중이면 비활성화
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue, 
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("비밀번호 변경", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}