import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/ex/date_ex.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/widgets/custom_elevated_button.dart';
import '../../core/widgets/custom_tab_bar.dart';
import '../../core/widgets/custom_text_button.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../firebase/firebase_service.dart';
import '../../l10n/app_localizations.dart';
import '../../model/category_model.dart';
import '../../model/event_model.dart';
import '../event_detail/event_detail_provider.dart';

class EditEventScreen extends StatefulWidget {
  EditEventScreen({super.key, required this.currentEvent});

  EventModel currentEvent;
  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late AppLocalizations appLocalizations = AppLocalizations.of(context)!;
  DateTime selectedDateTime = DateTime.now(); /// 24/3/2026 -> 9:44
  TimeOfDay pickedTime = TimeOfDay.now();
  late CategoryModel selectedCategory = CategoryModel.getCategories(context)[0];
  late TextEditingController _titleController ;
  late TextEditingController _descriptionController ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    }
    @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
        _titleController.text = widget.currentEvent.title ?? "";
        _descriptionController.text = widget.currentEvent.description ?? "";
        selectedDateTime = widget.currentEvent.dateTime ?? DateTime.now();
        pickedTime = TimeOfDay.fromDateTime(selectedDateTime);
        selectedCategory = CategoryModel.getCategories(context).firstWhere((category) => category.id == widget.currentEvent.category?.id);

  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.add_event),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  REdgeInsets.symmetric(horizontal: 16),
          child: Column(
        
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(ImageAssets.meeting)),
              SizedBox(height: 16.h,),
        
              CustomTabBar(
                categories: CategoryModel.getCategories(context),
                selectedCategoryIndex: int.parse(widget.currentEvent.category!.id) ?? 0,
                onCategoryItemClicked: (newCategory){
                setState(() {
                  selectedCategory = newCategory;
                  print("===> selected new category: $newCategory");
                });
                print(newCategory.name);
              },),
              SizedBox(height: 16.h,),
              Text(appLocalizations.title, style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              CustomTextFormField(
                  controller: _titleController,
                  hintText: appLocalizations.event_title),
              SizedBox(height: 16.h,),
              Text(appLocalizations.description, style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              CustomTextFormField(
                controller: _descriptionController,
                hintText: appLocalizations.event_description, maxLines: 4,),
              SizedBox(height: 16.h,),
              Row(
                children: [
                  Icon(Icons.date_range_outlined),
                  SizedBox(width: 4.w,),
                  Text(selectedDateTime.getFormattedDate, style: Theme.of(context).textTheme.displayLarge,),
                  Spacer(),
                  CustomTextButton(
                    title: appLocalizations.choose_date, onTap: _selectEventData
                    ,)
                ],
              ),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 4.w,),
                  Text(selectedDateTime.getFormattedTime, style: Theme.of(context).textTheme.displayLarge,),
                  Spacer(),
                  CustomTextButton(title: appLocalizations.choose_time, onTap: _chooseEventTime,)
        
                ],
        
        
              ),
        
              SizedBox(height: 24,),
              CustomElevatedButton(title: "Update Event", onClick: _updateEvent,),
              SizedBox(height: 24,),

            ],
          ),
        ),
      ),
    );
  }

  void _updateEvent()async{
    EventModel updatedEvent = EventModel(
        ownerId: widget.currentEvent.ownerId,
        id: widget.currentEvent.id,
        category: selectedCategory,
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: selectedDateTime == widget.currentEvent.dateTime ? DateTime.now() : selectedDateTime);
    print("===> updated event: $updatedEvent");
    await FirebaseService.updateEvent(updatedEvent, context);
    if (!mounted) return;
    Provider.of<EventDetailProvider>(context, listen: false).updateEvent(updatedEvent);
    Navigator.pop(context);
  }

  void _selectEventData()async {
    selectedDateTime = await   showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365))) ?? selectedDateTime;
    selectedDateTime = selectedDateTime.copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
    setState(() {

    });
  }



  void _chooseEventTime() async{
    pickedTime = await  showTimePicker(context: context, initialTime: TimeOfDay.now()) ??pickedTime ;
    selectedDateTime = selectedDateTime.copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
    setState(() {

    });
  }


}
