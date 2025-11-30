//다음 결제 예정일, 결제 금액을 가져온다. -> 현재 로그인 중인 user_id를 가지고 조회하도록 코드 수정 필요
//입력 : 플랫폼 이름(이것만 가져온다.) or null(전부 다 가져온다.)
//동작 : 현재 로그인 되어 있는 user_id를 가지고 구독 중인 플랫폼의 
//payment_due_date, payment_amout를 가져온다.
//리턴 : PlatformInfo 구조체 리턴(id, name, paymentduedate, paymentamount)

import 'package:supabase_flutter/supabase_flutter.dart';

// id, name, 다음 결제 예정일, 결제 금액을 가져온다.
class PlatformInfo {
  final int id;                  // platforms.platform_id
  final String name;             // platforms.name
  final DateTime? paymentDueDate; // 다음 결제 예정일
  final int? paymentAmount;

  PlatformInfo({
    required this.id,
    required this.name,
    this.paymentDueDate,
    this.paymentAmount,
  });
}

class PlatformService {
  final SupabaseClient _supabase;

  PlatformService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  // 현재 결제일 기준 다음 결제 예정일(한 달 뒤)을 계산
  DateTime addOneMonth(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;

    final lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
    final safeDay = day > lastDayOfNextMonth ? lastDayOfNextMonth : day;

    return DateTime(
      nextYear,
      nextMonth,
      safeDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  Future<List<PlatformInfo>> fetchPlatforms() async {
    final user = _supabase.auth.currentUser;
    String userId;

    if (user == null) {
      userId = '9634de49-aa9f-4235-a1c6-68b5eb15adfd';
    } else {
      userId = user.id;
    }

    final subscribeRows = await _supabase
        .from('subscribe_info')
        .select('platform_id')
        .eq('user_id', userId);

    if (subscribeRows.isEmpty) {
      return [];
    }

    final platformIds =
        List<int>.from(subscribeRows.map((e) => e['platform_id'] as int));

    final platformRows = await _supabase
        .from('platforms')
        .select('platform_id, name')
        .inFilter('platform_id', platformIds);

    final plansRows = await _supabase
        .from('plans')
        .select('platform_id, payment_due_date, payment_amount')
        .eq('user_id', userId)
        .inFilter('platform_id', platformIds);

    final Map<int, Map<String, dynamic>> plansByPlatformId = {};
    for (final row in plansRows) {
      final pid = row['platform_id'] as int;
      plansByPlatformId[pid] = row;
    }

    return platformRows.map<PlatformInfo>((e) {
      final pid = e['platform_id'] as int;
      final plan = plansByPlatformId[pid];

      DateTime? nextDueDate;
      int? amount;

      if (plan != null) {
        if (plan['payment_due_date'] != null) {
          final rawDate = DateTime.parse(plan['payment_due_date'] as String);
          nextDueDate = addOneMonth(rawDate);
        }
        if (plan['payment_amount'] != null) {
          amount = (plan['payment_amount'] as num).toInt();
        }
      }

      return PlatformInfo(
        id: pid,
        name: e['name'] as String,
        paymentDueDate: nextDueDate,
        paymentAmount: amount,
      );
    }).toList();
  }

  /// name이 null이면 전체 리스트 리턴,
  /// name이 있으면 해당 name만 필터해서 리스트(0 또는 1개) 리턴
  Future<List<PlatformInfo>> fetchPlatformsByName(String? targetName) async {
    final allPlatforms = await fetchPlatforms();

    if (targetName == null) {
      // 모든 name에 대해 그대로 반환
      return allPlatforms;
    }

    // 특정 name에 해당하는 것만 필터
    return allPlatforms.where((p) => p.name == targetName).toList();
  }
}
