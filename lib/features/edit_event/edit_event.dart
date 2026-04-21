import 'package:evently_sat_online/core/ex/date_ex.dart';
import 'package:evently_sat_online/core/resources/assets_manager.dart';
import 'package:evently_sat_online/core/ui_utils/dialog_utils.dart';
import 'package:evently_sat_online/core/widgets/custom_elevated_button.dart';
import 'package:evently_sat_online/core/widgets/custom_tab_bar.dart';
import 'package:evently_sat_online/core/widgets/custom_text_button.dart';
import 'package:evently_sat_online/core/widgets/custom_text_form_field.dart';
import 'package:evently_sat_online/firebase/firebase_service.dart';
import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:evently_sat_online/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditEvent extends StatefulWidget {
  final EventModel event;

  const EditEvent({super.key, required this.event});

  @override
  State<EditEvent> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEvent> {
  late DateTime selectedDateTime;
  late TimeOfDay pickedTime;
  late CategoryModel selectedCategory;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    selectedDateTime = widget.event.dateTime ?? DateTime.now();
    pickedTime = TimeOfDay.fromDateTime(selectedDateTime);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      var categories = CategoryModel.getCategories(context);
      selectedCategory = categories.firstWhere(
        (cat) => cat.id == widget.event.category?.id,
        orElse: () => categories[0],
      );
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(ImageAssets.meeting)),
              SizedBox(height: 16.h),
              CustomTabBar(
                categories: CategoryModel.getCategories(context),
                initialIndex: CategoryModel.getCategories(context)
                    .indexWhere((cat) => cat.id == selectedCategory.id),
                onCategoryItemClicked: (newCategory) {
                  setState(() {
                    selectedCategory = newCategory;
                  });
                },
              ),
              SizedBox(height: 16.h),
              Text(
                appLocalizations.title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                  controller: _titleController,
                  hintText: appLocalizations.event_title),
              SizedBox(height: 16.h),
              Text(
                appLocalizations.description,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8.h),
              CustomTextFormField(
                controller: _descriptionController,
                hintText: appLocalizations.event_description,
                maxLines: 4,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  const Icon(Icons.date_range_outlined),
                  SizedBox(width: 4.w),
                  Text(
                    selectedDateTime.getFormattedDate,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Spacer(),
                  CustomTextButton(
                    title: appLocalizations.choose_date,
                    onTap: _selectEventData,
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  SizedBox(width: 4.w),
                  Text(
                    selectedDateTime.getFormattedTime,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Spacer(),
                  CustomTextButton(
                    title: appLocalizations.choose_time,
                    onTap: _chooseEventTime,
                  )
                ],
              ),
              SizedBox(height: 24.h),
              CustomElevatedButton(
                title: "Update Event",
                onClick: _updateEvent,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  void _updateEvent() async {
    widget.event.title = _titleController.text;
    widget.event.description = _descriptionController.text;
    widget.event.category = selectedCategory;
    widget.event.dateTime = selectedDateTime;

    DialogUtils.showLoading(context);
    await FirebaseService.updateEvent(widget.event, context);
    DialogUtils.hideDialog(context);
    DialogUtils.showToastMessage(
        message: "Event Updated Successfully", bgColor: Colors.green);
    Navigator.pop(context);
  }

  void _selectEventData() async {
    selectedDateTime = await showDatePicker(
            context: context,
            initialDate: selectedDateTime,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365))) ??
        selectedDateTime;
    selectedDateTime = selectedDateTime.copyWith(
        hour: pickedTime.hour, minute: pickedTime.minute);
    setState(() {});
  }

  void _chooseEventTime() async {
    pickedTime = await showTimePicker(
            context: context, initialTime: pickedTime) ??
        pickedTime;
    selectedDateTime = selectedDateTime.copyWith(
        hour: pickedTime.hour, minute: pickedTime.minute);
    setState(() {});
  }
}
