// lib/view/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/style.dart'; 
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    
    // 0.5초 뒤 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _startAnimation = true;
      });
    });

    // 3초 뒤 로그인 화면으로 이동
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. [애니메이션 레이어] 폴더로 들어가는 아이콘들
          // 위치는 그대로 두고 크기만 키웠습니다.
          _buildIncomingIcon(Icons.play_circle_fill, Colors.red, -80, 200),     
          _buildIncomingIcon(Icons.movie, Colors.black, 80, 250),              
          _buildIncomingIcon(Icons.music_note, Colors.green, -120, 300),       
          _buildIncomingIcon(Icons.shopping_bag, Colors.blue, 100, 180),       
          _buildIncomingIcon(Icons.local_shipping, Colors.orange, 0, 350),     

          // 2. [고정 레이어] 상단 MONO, 중앙 폴더, 하단 슬로건
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              // [상단] MONO 텍스트
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.15), 
                child: const Text(
                  "MONO",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColor.textBlack,
                    letterSpacing: 2.0,
                  ),
                ),
              ),

              // [중앙] 우리 파일 로고 (폴더 아이콘)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_copy_rounded,
                  size: 60,
                  color: AppColor.primaryBlue,
                ),
              ),

              // [하단] 슬로건
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.1), 
                child: const Text(
                  "모두 모아 한 번에.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 폴더로 빨려 들어가는 아이콘 위젯
  Widget _buildIncomingIcon(IconData icon, Color color, double offsetX, double startYOffset) {
    // 화면 중앙 좌표
    final centerX = MediaQuery.of(context).size.width / 2 - 27.5; // 아이콘 크기(55) 절반 보정
    final centerY = MediaQuery.of(context).size.height / 2 - 27.5;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1500), 
      curve: Curves.easeOutQuart,
      
      // 애니메이션 이동 경로 설정
      left: _startAnimation ? centerX : centerX + offsetX,
      top: _startAnimation ? centerY : centerY + startYOffset,
      
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 1500),
        opacity: _startAnimation ? 0.0 : 1.0, 
        child: Transform.scale(
          scale: _startAnimation ? 0.5 : 1.0, 
          // [수정됨] 아이콘 크기를 40 -> 55로 키움!
          child: Icon(icon, size: 55, color: color.withOpacity(0.6)),
        ),
      ),
    );
  }
}