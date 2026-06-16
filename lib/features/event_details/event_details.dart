import 'package:evently_sat_online/core/resources/assets_manager.dart';
import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/core/routes_manager/routes_manager.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/model/event_model.dart';
import 'package:evently_sat_online/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final currentUser = UserModel.currentUser;

    return Scaffold(
      backgroundColor: ColorsManager.whiteF4,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: Image.asset("assets/images/back.png"),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Event details",
          style: TextStyle(
            color: ColorsManager.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),

        actions: [
          if (event.ownerId == currentUser?.id) ...[
            IconButton(
              icon: Image.asset("assets/images/edit.png"),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutesManager.editEvent,
                  arguments: event,
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            IconButton(
              icon: Image.asset("assets/images/delete.png"),
              onPressed: () {
                _showDeleteDialog(event.id!);
              },
            ),
          ]
        ],
      ),

      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                ImageAssets.meeting,
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16.h),
            
            Text(
              event.title ?? "",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 12.h),
            
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: ColorsManager.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset("assets/images/calendar-add.png"),
                    const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMMM')
                              .format(event.dateTime!),
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorsManager.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          DateFormat('hh:mm a')
                              .format(event.dateTime!),
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorsManager.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),
            
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 8.h),
            
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: REdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      event.description ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsManager.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Event"),
          content:
          const Text("Are you sure you want to delete this event?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseService.deleteEvent(id, context);

                if (!mounted) return;
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // back

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Event deleted")),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
