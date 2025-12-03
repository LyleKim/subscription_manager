import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/style.dart';
import 'subscription_model.dart';
import '../../controllers/platform_unregistration_controller.dart';
import '../../controllers/update_plan_controller.dart';

class ListDetailScreen extends StatefulWidget {
  final SubscriptionModel subscription;

  const ListDetailScreen({super.key, required this.subscription});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  late SubscriptionModel currentData;
  final PlatformUnregistrationController _unregistrationController =
      PlatformUnregistrationController();
  final PlanController _planController = PlanController();

  @override
  void initState() {
    super.initState();
    currentData = widget.subscription;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###");
    final dDay = currentData.paymentDate.isAfter(DateTime.now())
        ? currentData.paymentDate.difference(DateTime.now()).inDays
        : 0;
    final isOngoingSubscription =
        currentData.endDate.year == 2099 &&
            currentData.endDate.month == 12 &&
            currentData.endDate.day == 31;

    return Scaffold(
      backgroundColor: AppColor.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // 이전 화면(ListScreen)으로 결과값 true 전달 → ListScreen에서 새로고침
            Navigator.pop(context, true);
          },
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: _buildIcon(currentData.platformName),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentData.platformName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${currencyFormat.format(currentData.price)}원 / 월",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
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
                          _buildDetailRow(
                            "이용중인 요금제",
                            currentData.planName,
                            isBold: true,
                          ),
                          const Divider(height: 32),
                          _buildDetailRow(
                            "결제일",
                            "${DateFormat('yyyy년 MM월 dd일').format(currentData.paymentDate)} (D-$dDay)",
                            highlightColor: AppColor.primaryBlue,
                            isBold: true,
                          ),
                          const Divider(height: 32),
                          _buildDetailRow(
                            "이용 기간",
                            isOngoingSubscription
                                ? "구독 중"
                                : "${DateFormat('yy.MM.dd').format(currentData.startDate)} ~ ${DateFormat('yy.MM.dd').format(currentData.endDate)}",
                          ),
                          const Divider(height: 32),
                          _buildDetailRow(
                            "계정 정보",
                            currentData.accountHint,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              color: AppColor.backgroundGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => _showEditSheet(context),
                    child: const Text(
                      "[수정하기]",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showDeleteDialog(context),
                    child: const Text(
                      "[구독 취소]",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String name) {
    IconData icon = Icons.subscriptions;
    Color color = Colors.grey;

    if (name.contains("Netflix")) {
      icon = Icons.movie;
      color = Colors.red;
    } else if (name.contains("Spotify")) {
      icon = Icons.music_note;
      color = Colors.green;
    } else if (name.contains("GPT")) {
      icon = Icons.bolt;
      color = Colors.teal;
    }

    return Icon(icon, size: 40, color: color);
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? highlightColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: highlightColor ?? AppColor.textBlack,
          ),
        )
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    final planController =
        TextEditingController(text: currentData.planName);
    final priceController =
        TextEditingController(text: currentData.price.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "정보 수정",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: planController,
                decoration:
                    const InputDecoration(labelText: "요금제 이름"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration:
                    const InputDecoration(labelText: "가격 (원)"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                  ),
                  onPressed: () async {
                    final newPrice =
                        int.tryParse(priceController.text) ??
                            currentData.price;
                    final newPlan = planController.text;

                    // DB 업데이트 호출
                    final success = await _planController.savePlan(
                      planId: currentData.planId,
                      platformName: currentData.platformName,
                      planName: newPlan,
                      paymentAmount: newPrice,
                    );

                    if (success) {
                      // 로컬 상태 갱신
                      final updatedItem = currentData.copyWith(
                        price: newPrice,
                        planName: newPlan,
                      );

                      setState(() {
                        currentData = updatedItem;
                      });

                      if (context.mounted) {
                        Navigator.pop(context); // 바텀시트 닫기
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('정보가 수정되었습니다.'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('수정에 실패했습니다. 다시 시도해주세요.'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    "저장하기",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("구독취소 하시겠습니까?"),
          content: const Text("구독이 취소되면 목록에서 사라집니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                "취소",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                bool isSuccess = false;

                try {
                  // 예외만 체크하고, 에러 없으면 성공으로 간주
                  final deleteCount =
                      await _unregistrationController
                          .cancelPlatformSubscription(
                    platformName: currentData.platformName,
                  );
                  debugPrint('deleteCount: $deleteCount'); // 디버깅용
                  isSuccess = true;
                } catch (e) {
                  debugPrint('Unregistration error: $e');
                  isSuccess = false;
                }

                if (isSuccess && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('구독이 취소되었습니다!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('구독 취소에 실패했습니다. 다시 시도해주세요.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text(
                "확인",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
