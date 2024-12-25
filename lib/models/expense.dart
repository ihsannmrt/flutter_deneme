import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Categories {
  food,
  travel,
  leisure,
  work,
}

const ExpensesCategoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.travel: Icons.flight,
  Categories.leisure: Icons.movie,
  Categories.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Categories category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.categories,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.categories)
      : expenses = allExpenses
      .where((expense) => expense.category == categories)
      .toList();

  final Categories categories;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final Expense expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}

double calculateTotalExpense(List<Expense> expenses) {
  double sum = 0.0;

  for (var item in expenses) {
    sum += item.amount;
  }

  return sum;
}
