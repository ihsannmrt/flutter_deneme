import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();

enum Categories {
  food,
  travel,
  leisure,
  work,
}

const InComeCategoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.travel: Icons.flight,
  Categories.leisure: Icons.movie,
  Categories.work: Icons.work,
};

class InCome {
  final String title;
  final double amount;
  final DateTime date;

  InCome({
    required this.title,
    required this.amount,
    required this.date,
  });
}


double calculateTotalInCome(List<InCome> income) {
  double sum = 0.0;

  for (var item in income) {
    sum += item.amount;
  }

  return sum;
}