import 'package:supabase_flutter/supabase_flutter.dart';

class PlatformInfo {
  final int id;
  final String name;
  final DateTime? paymentDueDate;
  final int? paymentAmount;
  final String? planName;
  final int? planId;
  final DateTime? startDate;
  final DateTime? endDate;

  PlatformInfo({
    required this.id,
    required this.name,
    this.paymentDueDate,
    this.paymentAmount,
    this.planName,
    this.planId,
    this.startDate,
    this.endDate,
  });
}

class PlatformService {
  final SupabaseClient _supabase;

  PlatformService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

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
        .select('platform_id, start_date, end_date')
        .eq('user_id', userId);

    if (subscribeRows.isEmpty) {
      return [];
    }

    final platformIds =
        List<int>.from(subscribeRows.map((e) => e['platform_id'] as int));

    final subscribeInfoByPlatformId = <int, Map<String, dynamic>>{};
    for (final row in subscribeRows) {
      final pid = row['platform_id'] as int;
      subscribeInfoByPlatformId[pid] = row;
    }

    final platformRows = await _supabase
        .from('platforms')
        .select('platform_id, name')
        .inFilter('platform_id', platformIds);

    final plansRows = await _supabase
        .from('plans')
        .select('plan_id, platform_id, payment_due_date, payment_amount, plan_name')
        .eq('user_id', userId)
        .inFilter('platform_id', platformIds);

    final plansByPlatformId = <int, Map<String, dynamic>>{};
    for (final row in plansRows) {
      final pid = row['platform_id'] as int;
      plansByPlatformId[pid] = row;
    }

    return platformRows.map<PlatformInfo>((e) {
      final pid = e['platform_id'] as int;
      final plan = plansByPlatformId[pid];
      final subscribeInfo = subscribeInfoByPlatformId[pid];

      DateTime? nextDueDate;
      int? amount;
      String? planName;
      int? planId;
      DateTime? startDate;
      DateTime? endDate;

      if (plan != null) {
        if (plan['plan_id'] != null) {
          planId = plan['plan_id'] as int;
        }
        if (plan['payment_due_date'] != null) {
          final rawDate = DateTime.parse(plan['payment_due_date'] as String);
          nextDueDate = addOneMonth(rawDate);
        }
        if (plan['payment_amount'] != null) {
          amount = (plan['payment_amount'] as num).toInt();
        }
        if (plan['plan_name'] != null) {
          planName = plan['plan_name'] as String;
        }
      }

      if (subscribeInfo != null) {
        if (subscribeInfo['start_date'] != null) {
          startDate = DateTime.parse(subscribeInfo['start_date'] as String);
        }
        if (subscribeInfo['end_date'] != null) {
          endDate = DateTime.parse(subscribeInfo['end_date'] as String);
        } else {
          endDate = DateTime(2099, 12, 31);
        }
      }

      return PlatformInfo(
        id: pid,
        name: e['name'] as String,
        paymentDueDate: nextDueDate,
        paymentAmount: amount,
        planName: planName,
        planId: planId,
        startDate: startDate,
        endDate: endDate,
      );
    }).toList();
  }

  Future<List<PlatformInfo>> fetchPlatformsByName(String? targetName) async {
    final allPlatforms = await fetchPlatforms();

    if (targetName == null) {
      return allPlatforms;
    }

    return allPlatforms.where((p) => p.name == targetName).toList();
  }
}
