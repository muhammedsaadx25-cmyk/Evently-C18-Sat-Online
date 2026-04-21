import 'package:evently_sat_online/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CategoryModel{
  String id;
  String name;
  IconData icon;
  String image;
  CategoryModel({required this.id, required this.name, required this.icon, required this.image});



Map<String, dynamic> toJson()=>{
  'id':id,
  'name': name,
  'image':image
};

  static List<CategoryModel> getCategories(BuildContext context){
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

     List<CategoryModel> categories = [
       CategoryModel(id: "1", name: appLocalizations.sports, icon: Icons.sports_football, image: ''),
       CategoryModel(id: "2", name: appLocalizations.birthday, icon: Icons.cake_outlined, image: ''),
      CategoryModel(id: "3", name:appLocalizations.book_club, icon: Icons.bookmark_border_outlined, image: ''),
      CategoryModel(id: "4", name: appLocalizations.exhibition, icon: Icons.water_drop_rounded, image: ''),
    ];
     return categories;
  }
  static List<CategoryModel> getCategoriesWithAll(BuildContext context){
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

     List<CategoryModel> categories = [
       CategoryModel(id: "0", name: appLocalizations.all, icon: Icons.all_inclusive, image: ''),

       CategoryModel(id: "1", name: appLocalizations.sports, icon: Icons.sports_football, image: ''),
       CategoryModel(id: "2", name: appLocalizations.birthday, icon: Icons.cake_outlined, image: ''),
      CategoryModel(id: "3", name:appLocalizations.book_club, icon: Icons.bookmark_border_outlined, image: ''),
      CategoryModel(id: "4", name: appLocalizations.exhibition, icon: Icons.water_drop_rounded, image: ''),
    ];
     return categories;
  }
}