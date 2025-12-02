// lib/view/list/list_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/style.dart';
import 'subscription_model.dart';

// ✅ 수정이 되면 화면을 다시 그려야 하므로 StatefulWidget으로 변경
class ListDetailScreen extends StatefulWidget {
  final SubscriptionModel subscription;

  const ListDetailScreen({super.key, required this.subscription});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  // 화면에 보여줄 데이터 (수정하면 이 변수가 바뀜)
  late SubscriptionModel currentData;

  @override
  void initState() {
    super.initState();
    currentData = widget.subscription;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###");

    return Scaffold(
      backgroundColor: AppColor.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          // 그냥 뒤로 갈 때는 변경 없음(null)
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // 로고
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,4))
                        ],
                      ),
                      child: _buildIcon(currentData.platformName), 
                    ),
                    const SizedBox(height: 16),
                    // 이름
                    Text(
                      currentData.platformName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // 가격
                    Text(
                      "${currencyFormat.format(currentData.price)}원 / 월",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // 상세 정보 카드
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("이용중인 요금제", currentData.planName, isBold: true),
                          const Divider(height: 32),
                          
                          _buildDetailRow(
                            "결제일", 
                            "${DateFormat('yyyy년 MM월 dd일').format(currentData.paymentDate)} (D-${currentData.dDay})",
                            highlightColor: AppColor.primaryBlue,
                            isBold: true
                          ),
                          const Divider(height: 32),
                          
                          _buildDetailRow(
                            "이용 기간", 
                            "${DateFormat('yy.MM.dd').format(currentData.startDate)} ~ ${DateFormat('yy.MM.dd').format(currentData.endDate)}"
                          ),
                          const Divider(height: 32),
                          
                          _buildDetailRow("계정 정보", currentData.accountHint, isBold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: AppColor.backgroundGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                       _showEditSheet(context); // ✅ 수정하기 바텀시트 호출
                    }, 
                    child: const Text("[수정하기]", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      _showDeleteDialog(context); // ✅ 삭제하기 다이얼로그 호출
                    }, 
                    child: const Text("[구독 취소]", style: TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 아이콘 빌더
  Widget _buildIcon(String name) {
    IconData icon = Icons.subscriptions;
    Color color = Colors.grey;
    if (name.contains("Netflix")) { icon = Icons.movie; color = Colors.red; }
    else if (name.contains("Spotify")) { icon = Icons.music_note; color = Colors.green; }
    else if (name.contains("GPT")) { icon = Icons.bolt; color = Colors.teal; }
    return Icon(icon, size: 40, color: color);
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? highlightColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: highlightColor ?? AppColor.textBlack,
          ),
        ),
      ],
    );
  }

  // 📝 수정하기 바텀 시트 (간단하게 요금제와 가격만 수정)
  void _showEditSheet(BuildContext context) {
    final planController = TextEditingController(text: currentData.planName);
    final priceController = TextEditingController(text: currentData.price.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 키보드 올라왔을 때 화면 밀어올리기 위함
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, 
            left: 20, right: 20, top: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("정보 수정", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: planController,
                decoration: const InputDecoration(labelText: "요금제 이름"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "가격 (원)"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue),
                  onPressed: () {
                    // 1. 입력값으로 데이터 수정
                    final newPrice = int.tryParse(priceController.text) ?? currentData.price;
                    final newPlan = planController.text;

                    final updatedItem = currentData.copyWith(
                      price: newPrice,
                      planName: newPlan,
                    );

                    // 2. 전체 리스트(dummySubscriptions)에서도 찾아 바꿔치기
                    final index = dummySubscriptions.indexOf(widget.subscription);
                    if (index != -1) {
                      dummySubscriptions[index] = updatedItem;
                    }

                    // 3. 현재 화면 갱신
                    setState(() {
                      currentData = updatedItem;
                    });

                    Navigator.pop(context); // 시트 닫기
                  },
                  child: const Text("저장하기", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🗑️ 삭제(구독 취소) 로직
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("구독취소 하시겠습니까?"),
          content: const Text("리스트에서 즉시 사라집니다.\n(앱 재시작 시 복구됨)"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue),
              onPressed: () {
                // ✅ 1. 리스트에서 진짜로 삭제
                dummySubscriptions.remove(widget.subscription);
                
                Navigator.pop(context); // 팝업 닫기
                
                // ✅ 2. 이전 화면으로 돌아가면서 "나 바뀌었어!"(true) 신호 보내기
                Navigator.pop(context, true); 
              },
              child: const Text("확인", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}