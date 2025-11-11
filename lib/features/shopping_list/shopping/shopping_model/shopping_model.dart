import 'package:flutter/material.dart';

class ShoppingModel {
  final String title;
  final String description;
  final String image;
  final String createdBy;
  final String date;
  final bool isFinished;

  ShoppingModel({
    required this.title,
    required this.description,
    required this.image,
    required this.createdBy,
    required this.date,
    this.isFinished = false,
  });
}
