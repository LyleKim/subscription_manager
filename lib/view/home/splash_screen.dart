// 앱 초기화면

import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/style.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // 애니메이션 상태 관리
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    
    // 0.5초 뒤에 아이콘들이 가운데로 모임
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _startAnimation = true;
      });
    });

    // 2.5초 뒤에 로그인 화면으로 이동
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 배경에 흩어진 아이콘들 (애니메이션으로 위치 이동)
          _buildFloatingIcon(Icons.play_circle_fill, Colors.red, -100, -150), // 유튜브 느낌
          _buildFloatingIcon(Icons.movie, Colors.black, 120, -100),           // 넷플릭스 느낌
          _buildFloatingIcon(Icons.music_note, Colors.green, -120, 100),      // 스포티파이 느낌
          _buildFloatingIcon(Icons.shopping_bag, Colors.blue, 100, 150),      // 쿠팡 느낌

          // 중앙 로고 및 텍스트
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _startAnimation ? 1.0 : 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.all_inclusive, size: 80, color: AppColor.primaryBlue), // 우리 로고(임시)
                SizedBox(height: 20),
                Text(
                  "스마트한 구독 관리\n모두 모았다!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 두둥실 떠다니는 아이콘 위젯
  Widget _buildFloatingIcon(IconData icon, Color color, double startX, double startY) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 1, milliseconds: 500),
      curve: Curves.easeInOutBack, // 쫀득한 움직임
      // 애니메이션 시작 전엔 퍼져있고, 시작하면(true) 가운데(0,0) 근처로 모임
      left: _startAnimation ? MediaQuery.of(context).size.width / 2 + (startX / 4) - 20 : MediaQuery.of(context).size.width / 2 + startX,
      top: _startAnimation ? MediaQuery.of(context).size.height / 2 + (startY / 4) - 20 : MediaQuery.of(context).size.height / 2 + startY,
      child: Icon(icon, size: 40, color: color.withOpacity(0.5)),
    );
  }
}