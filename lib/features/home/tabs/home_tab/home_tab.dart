import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/core/widgets/custom_tab_bar.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:evently_sat_online/model/event_model.dart';
import 'package:evently_sat_online/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/event_item.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;
  late AppLocalizations appLocalizations = AppLocalizations.of(context)!;
late CategoryModel selectedCategory = CategoryModel.getCategoriesWithAll(context)[0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${appLocalizations.welcome_back} ✨",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      UserModel.currentUser!.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.light_mode_outlined),
                Card(
                  color: ColorsManager.darkBlue,
                  child: Padding(
                    padding: REdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text(
                      "EN",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          CustomTabBar(categories: CategoryModel.getCategoriesWithAll(context), onCategoryItemClicked: (newCategory){
            setState(() {
              selectedCategory = newCategory;

            });
          },),

          StreamBuilder(
            stream: FirebaseService.getEventsFromFireStoreRealTime(context,selectedCategory),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              List<EventModel> events = snapshot.data!;
              return Expanded(
                child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemBuilder: (context, index) =>
                            EventItem(event: events[index], markAsFavourite: UserModel.currentUser!.favouriteEventsIds.contains(events[index].id),),

                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemCount: events.length,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
