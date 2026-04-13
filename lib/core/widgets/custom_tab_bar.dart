
import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/core/widgets/tab_item.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
   CustomTabBar({super.key, required this.categories,this.onCategoryItemClicked });
List<CategoryModel> categories;
void Function(CategoryModel)? onCategoryItemClicked;
  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: widget.categories.length,
      child: TabBar(
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            widget.onCategoryItemClicked?.call(widget.categories[selectedIndex]);
          });
        },
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        tabs: widget.categories
            .map(
              (category) => TabItem(
            category: category,
            selectedBgColor: ColorsManager.darkBlue,
            selectedFgColor: Colors.white,
            unSelectedBgColor: ColorsManager.white,
            unSelectedFgColor: ColorsManager.black,
            isSelected:
            widget.categories.indexOf(category) ==
                selectedIndex,
          ),
        )
            .toList(),
      ),
    );
  }
}
