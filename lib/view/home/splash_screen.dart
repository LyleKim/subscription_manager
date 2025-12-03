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
  bool _startAnimation = false;

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _startAnimation = true;
      });
    });

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
        children: [
          // 배경 아이콘들
          _buildFloatingIcon(Icons.play_circle_fill, Colors.red, -100, -150),
          _buildFloatingIcon(Icons.movie, Colors.black, 120, -100),
          _buildFloatingIcon(Icons.music_note, Colors.green, -120, 100),
          _buildFloatingIcon(Icons.shopping_bag, Colors.blue, 100, 150),

          // 중앙 콘텐츠 (완벽 중앙 정렬)
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _startAnimation ? 1.0 : 0.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.all_inclusive, size: 80, color: AppColor.primaryBlue),
                  SizedBox(height: 20),
                  Text(
                    "스마트한 구독 관리\n모두 모았다!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color, double offsetX, double offsetY) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;

    return AnimatedPositioned(
      duration: const Duration(seconds: 1, milliseconds: 500),
      curve: Curves.easeInOutBack,
      left: _startAnimation 
          ? centerX + (offsetX / 4) - 20 
          : centerX + offsetX,
      top: _startAnimation 
          ? centerY + (offsetY / 4) - 20 
          : centerY + offsetY,
      child: Icon(icon, size: 40, color: color.withValues(alpha: 0.5)),
    );
  }
}
