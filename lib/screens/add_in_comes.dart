import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deneme/models/in_come.dart';
import 'package:intl/intl.dart';

class Add_InComes extends StatefulWidget {
  const Add_InComes({
    super.key,
    required this.onAddInCome,
  });

  final void Function(InCome income) onAddInCome;

  @override
  State<Add_InComes> createState() => _Add_InComesState();
}

String globalInComeTitle = '';

class _Add_InComesState extends State<Add_InComes> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

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

  void _submitInComeData() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      return; // Eğer başlık veya miktar boşsa işlem yapılmaz
    }

    globalInComeTitle = _titleController.text.trim();

    FirebaseFirestore.instance
        .collection('InComes')
        .doc(globalInComeTitle)
        .set({
      'amount': _amountController.text.trim(),
      'date': Timestamp.fromDate(_selectedDate!), // Varsayılan Timestamp formatı
      'title': globalInComeTitle,
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
       String displayedDate = _selectedDate != null
        ? DateFormat('MM-dd-yyyy').format(_selectedDate!)
        : 'Select Date!';

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: const Text(
          'Add InCome',
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
                maxLength: 30,
                controller: _titleController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  label: Text('InCome Name'),
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
                  Text(displayedDate), // Tarihi varsayılan formatta göster
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.date_range),
                  ),
                ],
              ),
              CustomSizedBox(),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitInComeData,
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox CustomSizedBox() => const SizedBox(height: 15);
}


/*
    submitInComeData() kodları

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
    widget.onAddInCome(
      InCome(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    */