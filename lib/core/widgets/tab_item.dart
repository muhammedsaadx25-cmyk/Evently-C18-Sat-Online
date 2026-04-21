import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabItem extends StatelessWidget {
  TabItem({
    super.key,
    required this.category,
    required this.selectedBgColor,
    required this.selectedFgColor,
    required this.unSelectedBgColor,
    required this.unSelectedFgColor,
    required this.isSelected,
  });

  CategoryModel category;
  Color selectedBgColor;
  Color selectedFgColor;
  Color unSelectedBgColor;
  Color unSelectedFgColor;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : unSelectedBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.grey, width: 1.w),
      ),

      child: Row(
        children: [
          Icon(
            category.icon,
            color: isSelected ? selectedFgColor : unSelectedFgColor,
          ),
          SizedBox(width: 8.w),
          Text(
            category.name,
            style: TextStyle(
              color: isSelected ? selectedFgColor : unSelectedFgColor,
            ),
          ),
        ],
      ),
    );
  }
}
