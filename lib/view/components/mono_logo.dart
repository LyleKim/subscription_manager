import 'package:flutter/material.dart';
import '../theme/style.dart';

class MonoLogo extends StatelessWidget {
  final bool isSmall; // true: 헤더/회원가입용(작게), false: 로그인용(크게)

  const MonoLogo({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    // 1. 사이즈 설정
    // 로그인 화면(큰 버전)에서는 40, 헤더(작은 버전)에서는 24
    final double size = isSmall ? 30.0 : 40.0;
    
    return Row(
      mainAxisSize: MainAxisSize.min, // 내용물만큼만 공간 차지
      crossAxisAlignment: CrossAxisAlignment.center, // 수직 중앙 정렬
      children: [
        // [로고 아이콘] 폴더 모양 (구독을 담는다는 의미)
        Container(
          padding: EdgeInsets.all(size * 0.2), // 아이콘 크기에 비례한 패딩
          decoration: BoxDecoration(
            color: AppColor.primaryBlue.withOpacity(0.1), // 연한 블루 배경
            shape: BoxShape.circle, // 둥근 사각형 느낌 (앱 아이콘처럼)
          ),
          child: Icon(
            Icons.folder_copy_rounded, // 둥근 폴더 아이콘
            size: size, 
            color: AppColor.primaryBlue,
          ),
        ),
        
        SizedBox(width: size * 0.3), // 아이콘과 텍스트 사이 간격

        // [로고 텍스트]
        Text(
          "MONO", 
          style: TextStyle(
            fontSize: size * 0.9, // 텍스트는 아이콘보다 살짝 작게
            fontWeight: FontWeight.w800, // 두께감 있게
            color: AppColor.textBlack,
            letterSpacing: -0.5, // 자간을 살짝 좁혀서 단단한 느낌
            height: 1.0,  
          ),
        ),
      ],
    );
  }
}