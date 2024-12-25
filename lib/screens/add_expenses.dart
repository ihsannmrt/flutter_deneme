import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deneme/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter_deneme/models/expense.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({
    super.key,
    required this.onAddExpense,
  });

  final void Function(Expense expense) onAddExpense;

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

String globalExpenseTitle = '';

class _AddExpensesState extends State<AddExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Categories _selectedCategory = Categories.food;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitExpenseData() {
    if (_selectedDate == null || _titleController.text.trim().isEmpty) {
      // Eğer tarih veya başlık boşsa işlem yapılmaz
      return;
    }

    globalExpenseTitle = _titleController.text.trim();
    globalSelectedDate = _selectedDate;

    // Firestore'a kaydedilecek veriyi hazırlıyoruz
    FirebaseFirestore.instance.collection('Expenses').doc(globalExpenseTitle).set({
      'amount': _amountController.text.trim(),
      'category': _selectedCategory.name,
      'date': Timestamp.fromDate(globalSelectedDate!), // Varsayılan Timestamp formatında kaydedilir
      'title': globalExpenseTitle,
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate != null
        ? DateFormat('MM-dd-yyyy').format(_selectedDate!)
        : 'Select Date!';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add Expense',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12,
          ),
          child: Column(
            children: [
              CustomSizedBox(),
              TextField(
                keyboardType: TextInputType.name,
                controller: _titleController,
                maxLength: 30,
                decoration: const InputDecoration(
                  label: Text('Expense Name'),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                        prefixText: '₺ ',
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(formattedDate),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.date_range),
                  )
                ],
              ),
              CustomSizedBox(),
              Row(
                children: [
                  DropdownButton(
                    padding: const EdgeInsets.only(left: 15),
                    value: _selectedCategory,
                    items: Categories.values
                        .map(
                          (categories) => DropdownMenuItem(
                            value: categories,
                            child: Text(
                              categories.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitExpenseData();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox CustomSizedBox() => const SizedBox(height: 15);
}


/*

submitExpensesData() verileri;

 final enteredAmount = double.tryParse(_amountController.text);
    final amountIsvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    */