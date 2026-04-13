import 'package:evently_sat_online/core/widgets/custom_text_form_field.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:evently_sat_online/model/event_model.dart';
import 'package:evently_sat_online/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/event_item.dart';

class FavouriteTab extends StatelessWidget {
  const FavouriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding:  REdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFormField(hintText: appLocalizations.search_for_event, suffixIcon: Icon(Icons.search),),
            SizedBox(height: 16.h,),
            FutureBuilder(future: FirebaseService.getFavouriteEvents(context,),
                builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()),);
              }
              List<EventModel> favouriteEvents = snapshot.data!;
              return  Expanded(
                child: ListView.separated(

                  itemBuilder: (context, index) => EventItem(
                    event: favouriteEvents[index],
                    markAsFavourite: true,
                  ),

                  separatorBuilder: (context, index)=>SizedBox(height: 16.h,),
                  itemCount: favouriteEvents.length,
                ),
              );
                })


          ],
        ),
      ),
    );
  }


}
