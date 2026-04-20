import 'package:evently_sat_online/core/ex/date_ex.dart';
import 'package:evently_sat_online/core/routes_manager/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/resources/assets_manager.dart';
import '../../core/resources/colors_manager.dart';
import '../../l10n/app_localizations.dart';
import '../../model/event_model.dart';
import '../../model/user_model.dart';
import 'event_detail_provider.dart';

class EventDetailScreen extends StatefulWidget {
  EventDetailScreen({super.key, required this.event});

  EventModel event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late AppLocalizations appLocalizations = AppLocalizations.of(context)!;


  @override
  void deactivate() {
    super.deactivate();
    Provider.of<EventDetailProvider>(context, listen: false).updateEvent(null);
  }
  @override
  Widget build(BuildContext context) {
    EventDetailProvider eventDetailProvider = Provider.of<EventDetailProvider>(context);
    EventModel? event = eventDetailProvider.currentEvent ?? widget.event;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.add_event),
        actions: [
          UserModel.currentUser!.id == widget.event.ownerId
              ? IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutesManager.editEvent, arguments: widget.event);
            },
            icon: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Icon(Icons.edit_outlined, color: ColorsManager.darkBlue),
            ),
          )
              : Container(),
          UserModel.currentUser!.id == widget.event.ownerId
              ? IconButton(
                  onPressed: () {},
                  icon: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(ImageAssets.meeting),
            ),
            SizedBox(height: 16.h),
            Text(
              event?.title ?? "",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 16.h),

            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F7FF),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(Icons.calendar_today, size: 24),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event?.dateTime?.getDayWithFullMonthName ?? "",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          event?.dateTime?.getTimeWithMarker ?? "",
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              appLocalizations.description,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 8.h),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  event?.description ?? "",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
