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

  @override
  Widget build(BuildContext context) {
    // [수정] _screens 리스트를 build 함수 안으로 옮겼습니다.
    // 이제 여기서 setState를 사용할 수 있습니다.
    final List<Widget> screens = [
      HomeScreen(
        onGoToList: () {
          setState(() {
            _selectedIndex = 1; // 리스트 탭(인덱스 1)으로 이동
          });
        },
      ),
      const ListScreen(),      // 1: 리스트 화면
      const LLMChatScreen(),   // 2: AI 분석
      const MyPageScreen(),    // 3: 마이페이지
    ];

    return Scaffold(
      // [수정] _screens 대신 위에서 만든 지역 변수 screens 사용
      body: screens[_selectedIndex], 
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),

        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColor.primaryBlue,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home_rounded),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            activeIcon: Icon(Icons.checklist_rounded),
            label: "리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: "분석",
          ),
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