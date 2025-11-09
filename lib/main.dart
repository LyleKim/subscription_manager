import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// void main() async {
//   //📲 runApp을 수행하기전에 비동기 작업을 할 경우 추가해주는 코드입니다
//   WidgetsFlutterBinding.ensureInitialized();
  
//   //📲 dotenv를 가져오는 부분
//   await dotenv.load();
  
//   //📲 dotenv 패키지를 사용해서 민감한 정보의 값들을 가져옵니다
//   await Supabase.initialize(
//     url: dotenv.get("PROJECT_URL"),
//     anonKey: dotenv.get("PROJECT_API_KEY"),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '구독 관리',
//       home: Scaffold(
//         appBar: AppBar(title: const Text('구독 관리')),
//         body: const Center(
//           child: Text('Supabase 연결 완료!'),
//         ),
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.get("PROJECT_URL"),
    anonKey: dotenv.get("PROJECT_API_KEY"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '구독 관리',
      home: InsertDataScreen(),
    );
  }
}

class InsertDataScreen extends StatefulWidget {
  const InsertDataScreen({super.key});
  @override
  State<InsertDataScreen> createState() => _InsertDataScreenState();
}

class _InsertDataScreenState extends State<InsertDataScreen> {
  String _result = '아직 입력 전';

  Future<void> insertPlatform() async {
    final response = await Supabase.instance.client
        .from('platforms')
        .insert({
          'name': '테스트 플랫폼', // 원하는 값으로 수정
          'group': '테스트 그룹' // 원하는 값으로 수정
        })
        .select(); // 결과를 select()로 가져옴

    setState(() {
      _result = response.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase 입력 테스트')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result),
            ElevatedButton(
              onPressed: insertPlatform,
              child: const Text('platforms 테이블에 데이터 입력'),
            )
          ],
        ),
      ),
    );
  }
}