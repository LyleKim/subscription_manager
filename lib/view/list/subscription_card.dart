import 'package:flutter/material.dart';
import '../theme/style.dart';
import 'subscription_model.dart';
import 'package:intl/intl.dart'; 

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onTap;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###"); // 17,000 처럼 콤마 찍기

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8), // 카드 간 간격
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
          children: [
            // 1. 로고 
            _buildPlatformLogo(subscription.platformName),
            const SizedBox(width: 16),

            // 2. 이름 및 플랜
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.platformName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subscription.planName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // 3. 가격 및 날짜
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${currencyFormat.format(subscription.price)}원", // 17,000
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${subscription.paymentDate.month}월 ${subscription.paymentDate.day}일",
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
  }

  // 로고 불러오는 함수
  Widget _buildPlatformLogo(String name) {
    IconData iconData = Icons.subscriptions;
    Color color = Colors.grey;

    if (name.contains("Netflix")) {
      iconData = Icons.movie; 
      color = Colors.red;
    } else if (name.contains("Spotify")) {
      iconData = Icons.music_note;
      color = Colors.green;
    } else if (name.contains("GPT")) {
      iconData = Icons.bolt;
      color = Colors.teal;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: color, size: 28),
    );
  }
}