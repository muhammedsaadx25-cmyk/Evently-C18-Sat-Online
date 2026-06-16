import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_sat_online/model/category_model.dart';
import 'package:flutter/material.dart';

class EventModel{
  String? ownerId;
  String? id;
  String? title;
  String? description;
  CategoryModel? category;
  DateTime? dateTime;
  EventModel({required this.ownerId,required this.id, required this.category, required this.title, required this.description, required this.dateTime});

EventModel.fromJson(Map<String, dynamic>? json, BuildContext context ) : this(
  ownerId: json?['ownerId'],
  id:  json?['id'],
  title: json?['title'],
  description: json?['description'],
  dateTime: (json?['dateTime'] as Timestamp ).toDate(),
  category: CategoryModel.getCategoriesWithAll(context).firstWhere((category)=>category.id == json?['categoryId']),

);
  Map<String,dynamic> toJson(){
    return {
      'ownerId': ownerId,
      'id':id,
      'title':title,
      'description':description,
      'dateTime':dateTime,
      'categoryId': category?.id,

    };
  }
}