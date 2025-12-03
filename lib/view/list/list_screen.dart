// lib/view/list/list_screen.dart

import 'package:flutter/material.dart';
import '../theme/style.dart';
import '../../controllers/user_name_controller.dart';
import '../../controllers/user_email_controller.dart';
import '../../controllers/platform_controller.dart';
import '../../services/platform_service.dart';

import '../../controllers/platform_registration_controller.dart';
import '../list/list_detail_screen.dart';
import '../list/subscription_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _sortType = 'date';

  final UserNameController _userNameController = UserNameController();
  final UserController _userController = UserController(); // UserController 인스턴스 추가
  final PlatformInfoController _platformInfoController = PlatformInfoController();
  final PlatformRegistrationController _registrationController =
      PlatformRegistrationController(); // ✅ 추가

  String? _userName;
  String? _userEmail; // 이메일 저장용 변수 추가
  List<PlatformInfo> _platforms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final name = await _userNameController.loadUserName();
      final email = await _userController.getUserEmail(); // 이메일 불러오기
      final platforms = await _platformInfoController.getPlatformsByName(null);

      setState(() {
        _userName = name ?? 'User';
        _userEmail = email ?? '';
        _platforms = platforms;
        _sortList(_sortType, needSetState: false);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userName = 'User';
        _userEmail = '';
        _platforms = [];
        _isLoading = false;
      });
    }
  }

  void _sortList(String type, {bool needSetState = true}) {
    _sortType = type;

    void doSort() {
      if (type == 'price') {
        _platforms.sort((a, b) {
          final pa = a.paymentAmount ?? 0;
          final pb = b.paymentAmount ?? 0;
          return pb.compareTo(pa);
        });
      } else if (type == 'name') {
        _platforms.sort((a, b) => a.name.compareTo(b.name));
      } else if (type == 'date') {
        _platforms.sort((a, b) {
          final da = a.paymentDueDate;
          final db = b.paymentDueDate;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return da.compareTo(db);
        });
      }
    }

    if (needSetState) {
      setState(doSort);
    } else {
      doSort();
    }
  }

  SubscriptionModel _toSubscriptionModel(PlatformInfo p) {
    return SubscriptionModel(
      platformName: p.name,
      price: p.paymentAmount ?? 0,
      planName: p.planName ?? '플랜 정보 없음',
      paymentDate: p.paymentDueDate ?? DateTime.now(),
      startDate: p.startDate ?? DateTime.now(),
      endDate: p.endDate ?? DateTime.now(),
      accountHint: _userEmail ?? '',
      planId: p.planId ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userName ?? 'User';
    final platformCount = _platforms.length;

    return Scaffold(
      backgroundColor: AppColor.backgroundGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "LOGO",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: userName,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: "님은\n",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: "$platformCount개",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: "의 플랫폼을 이용중!",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildSortButton("가격", "price"),
                        const SizedBox(width: 8),
                        Text("|",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400])),
                        const SizedBox(width: 8),
                        _buildSortButton("이름", "name"),
                        const SizedBox(width: 8),
                        Text("|",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400])),
                        const SizedBox(width: 8),
                        _buildSortButton("결제일", "date"),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
                    Expanded(
                      child: _platforms.isEmpty
                          ? const Center(
                              child: Text("구독 중인 서비스가 없습니다."),
                            )
                          : ListView.builder(
                              itemCount: _platforms.length,
                              itemBuilder: (context, index) {
                                final p = _platforms[index];

                                return InkWell(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  onTap: () async {
                                    final subscription =
                                        _toSubscriptionModel(p);

                                    final result =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ListDetailScreen(
                                          subscription: subscription,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      await _loadData();
                                    }
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(
                                            vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset:
                                              const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              p.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: AppColor
                                                    .textBlack,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              p.planName ??
                                                  '플랜 정보 없음',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              p.paymentAmount != null
                                                  ? "${p.paymentAmount}원"
                                                  : "- 원",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: AppColor
                                                    .textBlack,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              p.paymentDueDate != null
                                                  ? "${p.paymentDueDate!.month}월 ${p.paymentDueDate!.day}일"
                                                  : "다음 결제일 없음",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, top: 10),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            _showAddSheet(context);
                          },
                          child: Text(
                            "[ + 추가하기 ]",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
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
          fontWeight:
              isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? AppColor.primaryBlue
              : Colors.grey[600],
        ),
      ),
    );
  }

  // [+ 추가하기] 바텀시트: DB 반영 후 리스트 새로고침
  void _showAddSheet(BuildContext context) {
    final platformController = TextEditingController();
    final groupController = TextEditingController();
    final planController = TextEditingController();
    final priceController = TextEditingController();
    DateTime? startDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (bottomSheetContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "새 구독 추가",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 플랫폼 이름
                    TextField(
                      controller: platformController,
                      decoration:
                          const InputDecoration(labelText: "플랫폼 이름"),
                    ),
                    const SizedBox(height: 10),

                    // 그룹
                    TextField(
                      controller: groupController,
                      decoration: const InputDecoration(
                        labelText: "그룹 (예: OTT, 음악 등)",
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 요금제 이름
                    TextField(
                      controller: planController,
                      decoration:
                          const InputDecoration(labelText: "요금제 이름"),
                    ),
                    const SizedBox(height: 10),

                    // 결제 금액
                    TextField(
                      controller: priceController,
                      decoration:
                          const InputDecoration(labelText: "가격 (원)"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    // 구독 시작일
                    GestureDetector(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: bottomSheetContext,
                          initialDate: startDate ?? now,
                          firstDate: DateTime(now.year - 5),
                          lastDate: DateTime(now.year + 5),
                        );
                        if (picked != null) {
                          setModalState(() {
                            startDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              startDate == null
                                  ? "구독 시작일 선택"
                                  : "${startDate!.year}년 ${startDate!.month}월 ${startDate!.day}일",
                              style: TextStyle(
                                color: startDate == null
                                    ? Colors.grey
                                    : AppColor.textBlack,
                              ),
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBlue,
                        ),
                        onPressed: () async {
                          final name = platformController.text.trim();
                          final group = groupController.text.trim();
                          final planName = planController.text.trim();
                          final paymentAmountText =
                              priceController.text.trim();
                          final startDateText = startDate != null
                              ? "${startDate!.year.toString().padLeft(4, '0')}-"
                                "${startDate!.month.toString().padLeft(2, '0')}-"
                                "${startDate!.day.toString().padLeft(2, '0')}"
                              : "";

                          // 컨트롤러 호출 (성공: 1, 실패: 0)
                          final result = await _registrationController.register(
                            name: name,
                            group: group,
                            planName: planName,
                            paymentAmountText: paymentAmountText,
                            startDateText: startDateText,
                          );

                          if (!mounted) return; // ListScreen이 여전히 살아있는지 확인 [file:91]

                          if (result == 1) {
                            Navigator.pop(bottomSheetContext); // 바텀시트 닫기
                            await _loadData();       // DB에서 다시 조회

                            // ✅ ListScreen의 context로 스낵바 띄우기
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text('새 구독이 추가되었습니다.'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('구독 추가에 실패했습니다. 입력 값을 확인해주세요.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "추가하기",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
