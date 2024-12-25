import 'package:flutter_deneme/items/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deneme/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        background: Container(
          alignment: Alignment.centerLeft,
          color: Colors.red,
          height: double.infinity,
          width: double.infinity,
          child: const Icon(
            Icons.restore_from_trash,
            color: Colors.black,
            size: 60,
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          color: Colors.green,
          height: double.infinity,
          width: double.infinity,
          child: const Icon(
            Icons.check,
            color: Colors.black,
            size: 60,
          ),
        ),
        key: ValueKey(expenses[index]),
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
