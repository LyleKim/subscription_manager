import 'package:flutter/material.dart';
import '../theme/style.dart';
import '../../controllers/user_name_controller.dart';
import '../../controllers/user_email_controller.dart';
import '../../controllers/platform_controller.dart';
import '../../services/platform_service.dart';
import '../../controllers/platform_registration_controller.dart';
import '../list/list_detail_screen.dart';
import '../list/subscription_model.dart';
import '../../utils/logo_helper.dart'; 
import '../components/mono_logo.dart'; 

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String _sortType = 'date';

  final UserNameController _userNameController = UserNameController();
  final UserController _userController = UserController();
  final PlatformInfoController _platformInfoController = PlatformInfoController();
  final PlatformRegistrationController _registrationController = PlatformRegistrationController();

  String? _userName;
  String? _userEmail;
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
      // 유저 프로필 조회 (Return: name, email)
      final name = await _userNameController.loadUserName();
      final email = await _userController.getUserEmail();
      // 구독 리스트 전체 조회 (Return: List<PlatformInfo>)
      // 필드: id, name, paymentAmount, paymentDueDate, planName, group 등
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
      group: p.group,
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
                    
                    const Center(
                      child: MonoLogo(isSmall: true),
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
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    final subscription = _toSubscriptionModel(p);
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListDetailScreen(
                                          subscription: subscription,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      await _loadData();
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // 왼쪽 영역: 로고 + 이름
                                        Row(
                                          children: [
                                            // LogoHelper를 통해 그룹에 맞는 아이콘 표시
                                            LogoHelper.buildCategoryIcon(p.group, size: 40),
                                            
                                            const SizedBox(width: 12), 

                                            // 이름 및 플랜명
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p.name,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.textBlack,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  p.planName ?? '플랜 정보 없음',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        
                                        // 오른쪽 영역: 가격 + 결제일
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              p.paymentAmount != null
                                                  ? "${p.paymentAmount}원"
                                                  : "- 원",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.textBlack,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              p.paymentDueDate != null
                                                  ? "${p.paymentDueDate!.month}월 ${p.paymentDueDate!.day}일"
                                                  : "다음 결제일 없음",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
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
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
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
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColor.primaryBlue : Colors.grey[600],
        ),
      ),
    );
  }

  // 그룹을 텍스트 입력 대신 드롭박스로 선택
  void _showAddSheet(BuildContext context) {
    final platformController = TextEditingController();
    final planController = TextEditingController();
    final priceController = TextEditingController();
    DateTime? startDate;
    
    // 선택된 카테고리를 저장할 변수
    String? selectedGroup;

    // 카테고리 목록 (LogoHelper가 인식하는 키워드 위주)
    final List<String> categoryList = [
      'OTT',
      '음악',
      '쇼핑',
      '배달',
      '게임',
      'AI',
      '생활',
      '기타',
    ];

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
                    
                    // 1. 플랫폼 이름 (예: 넷플릭스)
                    TextField(
                      controller: platformController,
                      decoration: const InputDecoration(labelText: "플랫폼 이름"),
                    ),
                    const SizedBox(height: 10),

                    // 2. 카테고리 선택 (드롭다운)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "카테고리 (종류)",
                        border: UnderlineInputBorder(),
                      ),
                      value: selectedGroup,
                      items: categoryList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setModalState(() {
                          selectedGroup = newValue;
                        });
                      },
                      hint: const Text("선택해주세요"),
                    ),

                    const SizedBox(height: 10),
                    
                    // 3. 요금제 이름
                    TextField(
                      controller: planController,
                      decoration: const InputDecoration(labelText: "요금제 이름"),
                    ),
                    const SizedBox(height: 10),
                    
                    // 4. 가격
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "가격 (원)"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    
                    // 5. 날짜 선택
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    
                    // 6. 추가하기 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBlue,
                        ),
                        onPressed: () async {
                          final name = platformController.text.trim();
                          // 드롭다운에서 선택된 그룹 사용, 선택 안 했으면 '기타'로 처리
                          final group = selectedGroup ?? "기타";
                          final planName = planController.text.trim();
                          final paymentAmountText = priceController.text.trim();
                          
                          final startDateText = startDate != null
                              ? "${startDate!.year.toString().padLeft(4, '0')}-"
                                "${startDate!.month.toString().padLeft(2, '0')}-"
                                "${startDate!.day.toString().padLeft(2, '0')}"
                              : "";

                          if (name.isEmpty) {
                             ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('플랫폼 이름을 입력해주세요.')),
                            );
                            return;
                          }
                          
                          // 새 구독 추가 API (Create)
                          // Params: name, group(category), planName, price, startDate
                          final result = await _registrationController.register(
                            name: name,
                            group: group,
                            planName: planName,
                            paymentAmountText: paymentAmountText,
                            startDateText: startDateText,
                          );

                          if (!mounted) return;

                          if (result == 1) {
                            Navigator.pop(bottomSheetContext);
                            await _loadData();
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
                                content: Text('구독 추가에 실패했습니다. 입력 값을 확인해주세요.'),
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