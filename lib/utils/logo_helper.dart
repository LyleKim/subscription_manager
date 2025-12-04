import 'package:flutter/material.dart';
import '../view/theme/style.dart'; // AppColor가 정의된 파일

class LogoHelper {
  // 카테고리(그룹) 이름을 받아서 알맞은 아이콘 데이터를 반환
  static IconData getCategoryIcon(String? group) {
    if (group == null) return Icons.category_rounded;

    final lowerGroup = group.toLowerCase();

    if (lowerGroup.contains('ott') || lowerGroup.contains('영상')) {
      return Icons.movie_creation_rounded;
    } else if (lowerGroup.contains('음악') || lowerGroup.contains('music')) {
      return Icons.music_note_rounded;
    } else if (lowerGroup.contains('배달') || lowerGroup.contains('food')) {
      return Icons.delivery_dining_rounded;
    } else if (lowerGroup.contains('쇼핑') || lowerGroup.contains('shopping')) {
      return Icons.shopping_bag_rounded;
    } else if (lowerGroup.contains('ai')) {
      return Icons.smart_toy_rounded;
    } else if (lowerGroup.contains('게임') || lowerGroup.contains('game')) {
      return Icons.sports_esports_rounded;
    }
    
    return Icons.folder_open_rounded;
  }

  // 아이콘을 보여주는 위젯
  static Widget buildCategoryIcon(String? group, {double size = 40.0}) {
    final iconData = getCategoryIcon(group);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // [수정 포인트 1] Colors -> AppColor로 변경
        color: AppColor.primaryBlue.withOpacity(0.1), 
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        // [수정 포인트 2] Colors -> AppColor로 변경
        color: AppColor.primaryBlue, 
        size: size * 0.6,
      ),
    );
  }
}