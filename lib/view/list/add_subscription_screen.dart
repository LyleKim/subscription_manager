// lib/view/list/add_subscription_screen.dart

import 'package:flutter/material.dart';
import '../theme/style.dart';

class AddSubscriptionScreen extends StatelessWidget {
  const AddSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("구독 추가하기"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.construction, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text("", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}