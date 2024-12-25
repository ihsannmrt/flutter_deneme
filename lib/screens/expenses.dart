import 'package:flutter/material.dart';
import 'package:flutter_deneme/lists/expenses_list.dart';
import 'package:flutter_deneme/models/expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/screens/add_expenses.dart';
import 'package:flutter_deneme/widgets/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

void fetchExpenses() {
  FirebaseFirestore.instance
      .collection('Expenses')
      .orderBy('date', descending: true) // Tarihe göre sıralama (en yakın tarih üstte)
      .snapshots()
      .listen((snapshot) {
    final List<Expense> fetchedExpenses = snapshot.docs.map((doc) {
      final data = doc.data();

      // Tarihi Firestore'dan Timestamp olarak alıp DateTime'a çeviriyoruz
      Timestamp expenseTimestamp = data['date'] as Timestamp;

      return Expense(
        title: data['title'] ?? 'Unknown',
        amount: double.tryParse(data['amount']?.toString() ?? '0') ?? 0.0,
        date: expenseTimestamp.toDate(), // Varsayılan DateTime formatı
        category: Categories.values.firstWhere(
          (category) => category.name == data['category'],
          orElse: () => Categories.work,
        ),
      );
    }).toList();

    setState(() {
      expenses = fetchedExpenses;
    });
  });
}


  double getTotalAmount() {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => AddExpenses(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });

    FirebaseFirestore.instance.collection('Expenses').add({
      'amount': expense.amount,
      'category': expense.category.name,
      'date': Timestamp.fromDate(expense.date), // Varsayılan Timestamp formatı
      'title': expense.title,
    });
  }

  void _removeExpense(Expense expense) async {
    Expense? removedExpense = expense;
    int removedIndex = expenses.indexOf(expense);

    setState(() {
      expenses.remove(expense);
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Expenses')
          .where('title', isEqualTo: removedExpense.title)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      } else {
        print('No matching document found to delete');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${expense.title}" silindi.'),
          action: SnackBarAction(
            label: 'Geri Al',
            onPressed: () async {
              setState(() {
                expenses.insert(removedIndex, removedExpense);
              });

              await FirebaseFirestore.instance
                  .collection('Expenses')
                  .doc(removedExpense.title)
                  .set({
                'amount': removedExpense.amount,
                'category': removedExpense.category.name,
                'date': Timestamp.fromDate(removedExpense.date), // Varsayılan Timestamp formatı
                'title': removedExpense.title,
              });

              print('Expense "${removedExpense.title}" geri yüklendi.');
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: width * 0.3,
              child: const Text(
                'Expenses',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.start,
              ),
            ),
            const Spacer(),
            Text(
              '\₺${getTotalAmount().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const Spacer(),
            SizedBox(
              width: width * 0.3,
              child: IconButton(
                alignment: Alignment.bottomRight,
                onPressed: _openAddExpenseOverlay,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Chart(expenses: expenses),
          Expanded(
            child: expenses.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ExpensesList(
                    expenses: expenses,
                    onRemoveExpense: _removeExpense,
                  ),
          ),
        ],
      ),
    );
  }
}




















/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/models/expense.dart';
import 'package:flutter_deneme/screens/add_expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deneme/total_money.dart';
import 'package:flutter_deneme/widgets/chart.dart';
import 'package:flutter_deneme/lists/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Categories.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Categories.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => AddExpenses(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      registeredExpenses.add(expense);
    });
  }

  _removeExpense() {
    FirebaseFirestore.instance.collection('Expenses').doc(globalExpenseTitle).delete();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    Widget ExpensesMainContent = const Center(
      child: Text('No expenses found, Start adding some!'),
    );

    if (registeredExpenses.isNotEmpty) {
      ExpensesMainContent = ExpensesList(
        expenses: registeredExpenses,
        onRemoveExpense: _removeExpense(),
      );
    }

    double totalExpense = calculateTotalExpense(registeredExpenses);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: width * 0.3,
              child: const Text(
                'Expenses List',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              width: width * 0.32,
              child: Text(
                totalExpense.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: width * 0.3,
              child: IconButton(
                alignment: Alignment.bottomRight,
                onPressed: _openAddExpenseOverlay,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Chart(expenses: registeredExpenses),
          Expanded(
            child: ExpensesMainContent,
          ),
          const TotalMoney(),
        ],
      ),
    );
  }
}


/*
    removeExpenses() kod içeriği

    final expenseIndex = registeredExpenses.indexOf(expense);
    setState(() {
      registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                registeredExpenses.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );

        FirebaseFirestore.instance
        .collection('Expenses')
        .doc(_titleController)
        .delete();

        ****************

            if (registeredExpenses.isNotEmpty) {
      ExpensesMainContent = ExpensesList(
        expenses: registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    
    */
    */