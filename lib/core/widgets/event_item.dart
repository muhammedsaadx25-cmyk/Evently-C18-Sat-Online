import 'package:evently_sat_online/core/ex/date_ex.dart';
import 'package:evently_sat_online/core/resources/assets_manager.dart';
import 'package:evently_sat_online/core/resources/colors_manager.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventItem extends StatefulWidget {
   EventItem({super.key, required this.event, required this.markAsFavourite});
  EventModel event;
  bool markAsFavourite;

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
 late  bool favourite = widget.markAsFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,

      decoration: BoxDecoration(
borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(ImageAssets.meeting)),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: REdgeInsets.all(8),


            child: Padding(
              padding:  REdgeInsets.all(8.0),
              child: Text(widget.event.dateTime!.getMonth, style: Theme.of(context).textTheme.titleSmall,),
            ),
          ),
          SizedBox(height: 97.h,),
          Card(
            margin: REdgeInsets.all(8),
            child: Padding(
              padding:  REdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(child: Text(widget.event.title?? "", style: Theme.of(context).textTheme.titleMedium,)),
               IconButton(onPressed: _markEventAsFavourite, icon: Icon(favourite ? Icons.favorite : Icons.favorite_border))
              ],),
            ),
          )
        ],
      ),
    );
  }

  void _markEventAsFavourite()async{
    if(favourite){
      await FirebaseService.removeEventFromFavourite(widget.event);
    }else{

    await FirebaseService.addEventToFavourite(widget.event);
    }
    setState(() {
    favourite = !favourite;

    });

  }
}
