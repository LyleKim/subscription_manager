import 'package:flutter/material.dart';
import '../theme/style.dart'; 

import '../mypage/mypage_screen.dart';
import '../ai/llm_chat_screen.dart'; 
import '../home/home_screen.dart';
import '../list/list_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    //const Center(child: Text("홈 화면 (대시보드)")),
    const ListScreen(),
    const LLMChatScreen(), 
    const MyPageScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        
        type: BottomNavigationBarType.fixed, 
        backgroundColor: Colors.white,      
        selectedItemColor: AppColor.primaryBlue, 
        unselectedItemColor: Colors.grey[400],   
        showSelectedLabels: false,   
        showUnselectedLabels: false, 
        iconSize: 30, // 아이콘 크기 살짝 더 키움 (잘 보이게)

        items: const [
          // 1. 홈 (둥근 집 모양)
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), 
            activeIcon: Icon(Icons.home_rounded),    
            label: "홈", 
          ),
          
          // 2. 리스트 (체크리스트 모양 ✅)
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded), // 체크 표시가 있는 리스트
            activeIcon: Icon(Icons.checklist_rounded), // 꽉 찬 느낌
            label: "리스트",
          ),
          
          // 3. AI 분석 (반짝이 스파크 ✨ - AI 국룰 아이콘)
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined), 
            activeIcon: Icon(Icons.auto_awesome),    
            label: "분석",
          ),
          
          // 4. 마이페이지 (사람 모양)
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), 
            activeIcon: Icon(Icons.person_rounded),   
            label: "MY",
          ),
        ],
      ),
    );
  }
}