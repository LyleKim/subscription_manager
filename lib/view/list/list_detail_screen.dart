import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/style.dart';
import 'subscription_model.dart';
import '../../controllers/platform_unregistration_controller.dart';
import '../../controllers/update_plan_controller.dart';
import '../../utils/logo_helper.dart'; 
import '../components/mono_logo.dart'; 

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
        centerTitle: true, 
        title: const MonoLogo(isSmall: true),                        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
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
                      padding: const EdgeInsets.all(10), 
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25), 
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      // 서비스 로고 (넷플릭스, 유튜브 등)
                      child: LogoHelper.buildCategoryIcon(currentData.group, size: 80),
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
                          const Divider(height: 32),
                          _buildDetailRow(
                            "서비스 종류",
                            currentData.group,
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
    final planController = TextEditingController(text: currentData.planName);
    final priceController = TextEditingController(text: currentData.price.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
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
                  onPressed: () async {
                    final newPrice = int.tryParse(priceController.text) ?? currentData.price;
                    final newPlan = planController.text;
                    // 구독 정보 수정 API (Update)
                    // Params: planId, planName, paymentAmount
                    final success = await _planController.savePlan(
                      planId: currentData.planId,
                      platformName: currentData.platformName,
                      planName: newPlan,
                      paymentAmount: newPrice,
                    );

                    if (success) {
                      final updatedItem = currentData.copyWith(
                        price: newPrice,
                        planName: newPlan,
                      );

                      setState(() {
                        currentData = updatedItem;
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('정보가 수정되었습니다.'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('수정에 실패했습니다. 다시 시도해주세요.'), backgroundColor: Colors.red, duration: Duration(seconds: 3)),
                        );
                      }
                    }
                  },
                  child: const Text("저장하기", style: TextStyle(color: Colors.white)),
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
              child: const Text("취소", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryBlue),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                bool isSuccess = false;
                try {
                  // 구독 삭제 API (Delete)
                  // Params: platformName (또는 platformId)
                  final deleteCount = await _unregistrationController.cancelPlatformSubscription(
                    platformName: currentData.platformName,
                  );
                  debugPrint('deleteCount: $deleteCount');
                  isSuccess = true;
                } catch (e) {
                  debugPrint('Unregistration error: $e');
                  isSuccess = false;
                }

                if (isSuccess && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('구독이 취소되었습니다!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
                  );
                  Navigator.pop(context, true); 
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('구독 취소에 실패했습니다. 다시 시도해주세요.'), backgroundColor: Colors.red, duration: Duration(seconds: 3)),
                  );
                }
              },
              child: const Text("확인", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}