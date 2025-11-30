import 'package:flutter/material.dart';
import '../theme/style.dart';
import '../auth/login_screen.dart';
import 'mypage_change_pw.dart';   
// import 'mypage_edit_info.dart'; // 필요시 주석 해제

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String _userName = "김구독"; 
  bool _isEditingName = false;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
  }

  Color _getProfileColor(String name) {
    final colors = [Colors.redAccent, Colors.blueAccent, Colors.green, Colors.orange, Colors.purple];
    if (name.isEmpty) return Colors.grey;
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60), 
            
            // 상단 로고
            const Center(
              child: Chip(label: Text("LOGO", style: TextStyle(color: Colors.grey)), backgroundColor: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 30),

            // 메인 카드 (정보 박스)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              // [수정 1] 위아래 여백(vertical)을 24 -> 16으로 줄여서 높이를 낮춤
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // 프로필 영역
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: _getProfileColor(_userName),
                        child: Text(
                          _userName.isNotEmpty ? _userName[0] : "?",
                          style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      Expanded(
                        child: _isEditingName
                            ? TextField(
                                controller: _nameController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                                onSubmitted: (value) {
                                  setState(() {
                                    _userName = value;
                                    _isEditingName = false;
                                  });
                                },
                              )
                            : Text(_userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      
                      IconButton(
                        onPressed: () {
                          if (_isEditingName) {
                            setState(() {
                              _userName = _nameController.text;
                              _isEditingName = false;
                            });
                          } else {
                            setState(() {
                              _isEditingName = true;
                            });
                          }
                        },
                        icon: Icon(_isEditingName ? Icons.check : Icons.edit, size: 20, color: AppColor.primaryBlue),
                      ),
                    ],
                  ),
                  
                  // [수정 2] 간격을 20 -> 12로 줄임
                  const SizedBox(height: 12),
                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 8), // [수정 3] 간격을 10 -> 8로 줄임

                  // 메뉴 리스트
                  _buildMenuItem(context, "비밀번호 변경", const MyPageChangePw()),
                  
                  const SizedBox(height: 8), // [수정 3] 간격을 10 -> 8로 줄임
                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 8), // [수정 3] 간격을 10 -> 8로 줄임

                  // 로그아웃
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true, // [수정 4] 리스트 자체 높이를 살짝 줄여줌
                    title: const Text("로그아웃", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true, // [수정 4] 리스트 높이 압축
      title: Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("로그아웃 하시겠습니까?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue),
                      child: const Text("로그아웃", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0E0E0), elevation: 0),
                      child: const Text("취소", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}