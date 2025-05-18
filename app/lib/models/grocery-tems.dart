import 'package:flutter/material.dart';

class GroceryItem {
  final String name;
  final String qty;
  final String iconPath;
  bool isDone;

  GroceryItem({
    required this.name,
    required this.qty,
    required this.iconPath,
    required this.isDone,
  });
}
