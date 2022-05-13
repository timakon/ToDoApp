import 'package:flutter/material.dart';

class TodoItem {
  String uid;
  String title;
  String description;

  TodoItem({
    required this.uid,
    required this.title,
    required this.description,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     "title": title,
  //     "description": description,
  //   };
  // }

  // TodoItem.fromJson(String uid, Map<String, dynamic> data) {
  //   uid = uid;
  //   title = data['title'];
  //   description = data['description'];
  // }
}
