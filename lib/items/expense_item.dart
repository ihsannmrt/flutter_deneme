import 'package:flutter_deneme/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Text(
                expense.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '₺${expense.amount.toStringAsFixed(2)}',
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(ExpensesCategoryIcons[expense.category]),
                      const SizedBox(width: 8),
                      Text(expense.formattedDate),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
  firebaseconnectionExpense() {
    FirebaseFirestore.instance
        .collection('Expenses')
        .doc(globalTitle)
        .get()
        .then((gelenVeri) {
      setState(() {
        expense.title = gelenVeri.data()['title'];
      });
    });
  }
*/

/*
  firebaseconnectionExpense() {
  FirebaseFirestore.instance
      .collection('Expenses')
      .doc(globalTitle)
      .get()
      .then((gelenVeri) {
    final updatedExpense = Expense(
      title: gelenVeri.data()?['title'] ?? expense.title,
      amount: expense.amount,
      date: expense.date,
      category: expense.category,
    );
    // Daha sonra updatedExpense kullanabilirsiniz
  });
}
*/