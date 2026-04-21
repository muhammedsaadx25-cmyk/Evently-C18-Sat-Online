
import 'package:flutter/material.dart';

import '../../model/event_model.dart';

class EventDetailProvider extends ChangeNotifier{
  EventModel? currentEvent;

  updateEvent(EventModel? event){
    currentEvent = event;
    print("===> updated event: $event");
    notifyListeners();
  }
}