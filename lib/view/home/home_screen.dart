import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/home_data.dart';
import '../../controllers/home_controller.dart';
import '../../utils/logo_helper.dart';
import '../components/mono_logo.dart'; 

class HomeScreen extends StatefulWidget {
  // 메인 화면(MainNavScreen)에서 넘겨받을 함수
  final VoidCallback onGoToList;

  const HomeScreen({
    super.key, 
    required this.onGoToList, // 필수 값으로 설정
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<HomeData> _homeDataFuture;
  final HomeController _homeController = HomeController();

  final currencyFormat = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _homeController.fetchHomeData();
  }

  int _calculateDDay(DateTime paymentDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(paymentDate.year, paymentDate.month, paymentDate.day);
    return target.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, 
        title: const MonoLogo(isSmall: true), 
      ),
      backgroundColor: const Color(0xFFF3F3F3),
      body: FutureBuilder<HomeData>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("오류: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.subscriptions.isEmpty) {
            return const Center(child: Text("구독 내역이 없습니다."));
          }

          final data = snapshot.data!;
          final totalList = List<SubscriptionItem>.from(data.subscriptions);

          // 1. 빨간 알림 박스용 (0~3일 남은 것)
          final upcomingPayments = totalList.where((item) {
            final dDay = _calculateDDay(item.paymentDate);
            return dDay >= 0 && dDay <= 3;
          }).toList();

          // 2. 정렬 (D-Day 순)
          totalList.sort((a, b) {
            final dDayA = _calculateDDay(a.paymentDate);
            final dDayB = _calculateDDay(b.paymentDate);
            return dDayA.compareTo(dDayB);
          });

          // 3. 상위 3개 자르기
          final top3List = totalList.take(3).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 10),

                  // 빨간 알림 박스
                  if (upcomingPayments.isNotEmpty)
                    _buildNotificationSection(upcomingPayments),

                  // 총 지출 카드
                  _buildTotalExpenseSection(totalExpense: data.totalExpense),
                  
                  const SizedBox(height: 30),
                  
                  const Text(
                    "결제 예정 구독",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // 리스트 아이템들 (최대 3개)
                  ...top3List.map((item) {
                    return _buildSubscriptionItem(item);
                  }).toList(),

                  const SizedBox(height: 10),

                  // [수정됨] 버튼 클릭 시 탭 이동 함수 실행
                  if (data.subscriptions.length > 3)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // 부모(MainNavScreen)가 준 함수 실행 -> 탭 이동
                          widget.onGoToList(); 
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          "구독 전체 보기",
                          style: TextStyle(
                            color: Colors.black87, 
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 알림 섹션 위젯 (생략 없이 복구됨)
  Widget _buildNotificationSection(List<SubscriptionItem> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.redAccent, size: 20),
              SizedBox(width: 8),
              Text(
                "곧 결제될 구독이 있어요!",
                style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...items.map((item) {
            final dDay = _calculateDDay(item.paymentDate);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  LogoHelper.buildCategoryIcon(item.group, size: 24),
                  const SizedBox(width: 8),
                  Text(item.platformName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const Spacer(),
                  Text(dDay == 0 ? "오늘 결제" : "D-$dDay", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // 총 지출 섹션 위젯 (생략 없이 복구됨)
  Widget _buildTotalExpenseSection({required int totalExpense}) {
    final dailyCost = (totalExpense / 30).round();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('이번 달 총 구독료 지출', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text('₩ ${currencyFormat.format(totalExpense)}', style: const TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text('하루에 약 ${currencyFormat.format(dailyCost)}원씩 쓰고 있어요.', style: const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  // 리스트 아이템 위젯 (생략 없이 복구됨)
  Widget _buildSubscriptionItem(SubscriptionItem item) {
    final dDay = _calculateDDay(item.paymentDate);
    String dDayString;
    if (dDay == 0) dDayString = "Today";
    else if (dDay < 0) dDayString = "D+${dDay.abs()}";
    else dDayString = "D-$dDay";

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoHelper.buildCategoryIcon(item.group, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Text(item.platformName, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(15)),
              child: Text(dDayString, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}