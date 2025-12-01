// lib/view/list/list_screen.dart

import 'package:flutter/material.dart';
import '../theme/style.dart';
import 'subscription_model.dart';
import 'subscription_card.dart';
import 'list_detail_screen.dart';
import 'add_subscription_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _sortType = 'date';
  
  // 초기화 시 dummySubscriptions 데이터를 가져옴
  List<SubscriptionModel> currentList = [];

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 데이터 로드
    _refreshList();
  }

  // ✅ 리스트 새로고침 함수
  void _refreshList() {
    setState(() {
      // 전역 변수 dummySubscriptions에서 데이터를 다시 가져옴
      currentList = List.from(dummySubscriptions);
      _sortList(_sortType); // 정렬 상태 유지
    });
  }

  void _sortList(String type) {
    _sortType = type;
    setState(() {
      if (type == 'price') {
        currentList.sort((a, b) => b.price.compareTo(a.price));
      } else if (type == 'name') {
        currentList.sort((a, b) => a.platformName.compareTo(b.platformName));
      } else if (type == 'date') {
        currentList.sort((a, b) => a.dDay.compareTo(b.dDay));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // 헤더
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                     color: Colors.grey[300], 
                     borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("LOGO", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),

              // 타이틀
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "User", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const TextSpan(text: "님은\n", style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                    TextSpan(text: "${currentList.length}개", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const TextSpan(text: "의 플랫폼을 이용중!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 정렬 버튼
              Row(
                children: [
                  _buildSortButton("가격", "price"),
                  const SizedBox(width: 8),
                  Text("|", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                  const SizedBox(width: 8),
                  _buildSortButton("이름", "name"),
                  const SizedBox(width: 8),
                  Text("|", style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                  const SizedBox(width: 8),
                  _buildSortButton("결제일", "date"),
                ],
              ),
              
              const Divider(height: 24, thickness: 1),

              // 리스트
              Expanded(
                child: currentList.isEmpty 
                  ? const Center(child: Text("구독 중인 서비스가 없습니다."))
                  : ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      final sub = currentList[index];
                      return SubscriptionCard(
                        subscription: sub,
                        onTap: () async {
                          // ✅ 상세 페이지로 갔다가 돌아올 때 결과를 기다림 (await)
                          // result가 true면 뭔가 바뀌었다는 뜻 -> 새로고침
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListDetailScreen(subscription: sub),
                            ),
                          );

                          if (result == true) {
                            _refreshList(); // 리스트 다시 불러오기
                          }
                        },
                      );
                    },
                  ),
              ),

              // 추가하기 버튼
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const AddSubscriptionScreen()),
                      );
                    },
                    child: Text(
                      "[ + 추가하기 ]",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(String text, String type) {
    final isSelected = _sortType == type;
    return GestureDetector(
      onTap: () => _sortList(type),
      child: Text(
        text, 
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColor.primaryBlue : Colors.grey[600],
        )
      ),
    );
  }
}