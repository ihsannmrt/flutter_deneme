import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deneme/lists/in_comes_list.dart';
import 'package:flutter_deneme/models/in_come.dart';
import 'package:flutter_deneme/screens/add_in_comes.dart';
import 'package:intl/intl.dart'; // intl paketi eklendi

class InComes extends StatefulWidget {
  const InComes({super.key});

  @override
  State<InComes> createState() => _InComesState();
}

class _InComesState extends State<InComes> {
  List<InCome> incomes = [];

  @override
  void initState() {
    super.initState();
    fetchIncomes();
  }

void fetchIncomes() {
  FirebaseFirestore.instance
      .collection('InComes')
      .orderBy('date', descending: true) // Tarihe göre sıralama (en yakın tarih üstte)
      .snapshots()
      .listen((snapshot) {
    final List<InCome> fetchedIncomes = snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = data['date'] as Timestamp;

      return InCome(
        title: data['title'] ?? 'Unknown',
        amount: double.tryParse(data['amount']?.toString() ?? '0') ?? 0.0,
        date: timestamp.toDate(),
      );
    }).toList();

    setState(() {
      incomes = fetchedIncomes;
    });
  });
}


  void _openAddIncomeOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Add_InComes(onAddInCome: _addInCome),
    );
  }

  void _addInCome(InCome income) {
    final formattedDate = Timestamp.fromDate(DateTime(
      income.date.year,
      income.date.month, // Ay, gün, yıl sıralaması düzenlendi
      income.date.day,   // Tarihi doğru formatta kaydediyoruz
    ));

    setState(() {
      incomes.add(income);
    });

    FirebaseFirestore.instance.collection('InComes').add({
      'amount': income.amount,
      'date': formattedDate,
      'title': income.title,
    });
  }

  double getTotalIncome() {
    return incomes.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _removeIncome(InCome income) async {
    int removedIndex = incomes.indexOf(income);
    InCome removedIncome = income;

    setState(() {
      incomes.remove(income);
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('InComes')
          .where('title', isEqualTo: income.title)
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
          content: Text('"${income.title}" silindi.'),
          action: SnackBarAction(
            label: 'Geri Al',
            onPressed: () async {
              setState(() {
                incomes.insert(removedIndex, removedIncome);
              });

              await FirebaseFirestore.instance.collection('InComes').add({
                'amount': removedIncome.amount,
                'date': Timestamp.fromDate(DateTime(
                  removedIncome.date.year,
                  removedIncome.date.month, // Ay, gün, yıl sıralaması düzenlendi
                  removedIncome.date.day,
                )),
                'title': removedIncome.title,
              });

              print('Income "${removedIncome.title}" geri yüklendi.');
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  // Tarihi ay/gün/yıl formatında göstermek için kullanılan fonksiyon
  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date); // Tarih formatlama
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
                'InComes',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.start,
              ),
            ),
            const Spacer(),
            Text(
              '\₺${getTotalIncome().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const Spacer(),
            SizedBox(
              width: width * 0.3,
              child: IconButton(
                alignment: Alignment.bottomRight,
                onPressed: _openAddIncomeOverlay,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      body: incomes.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : InComesList(
              income: incomes,
              onRemoveInComes: _removeIncome,
              dateFormatter:
                  formatDate, // Tarih formatlama fonksiyonunu geçiriyoruz
            ),
    );
  }
}













/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_deneme/models/in_come.dart';
import 'package:flutter_deneme/screens/add_in_comes.dart';
import 'package:flutter/material.dart';

class InComes extends StatefulWidget {
  const InComes({super.key});

  @override
  State<InComes> createState() {
    return _InComeState();
  }
}

class _InComeState extends State<InComes> {
  final List<InCome> registeredInComes = [
    InCome(
      title: 'GlobalExecutiveAcademy Course',
      amount: 59.99,
      date: DateTime.now(),
      category: Categories.work,
    ),
    InCome(
      title: 'Go-Kart',
      amount: 10.00,
      date: DateTime.now(),
      category: Categories.leisure,
    )
  ];

  void _openAddInComeOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => Add_InComes(onAddInCome: _addInCome),
    );
  }

  void _addInCome(InCome income) {
    setState(() {
      registeredInComes.add(income);
    });
  }

  void _removeInComes() {
    FirebaseFirestore.instance.collection('InComes').doc(globalInComeTitle).delete();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    var totalInCome = calculateTotalInCome(registeredInComes);

    Widget InComesMainContent = const Center(
      child: Text('No incomes found, Start adding some!'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: width * 0.3,
              child: const Text(
                'InComes List',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
                width: width * 0.32,
                child: Text(totalInCome.toStringAsFixed(2),
                    textAlign: TextAlign.center)),
            SizedBox(
              width: width * 0.3,
              child: IconButton(
                alignment: Alignment.centerRight,
                onPressed: _openAddInComeOverlay,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          Expanded(
            child: InComesMainContent,
          ),
        ],
      ),
    );
  }
}
*/

/*
remove işlemi içerik

      final incomeIndex = registeredInComes.indexOf(income);
    setState(() {
      registeredInComes.remove(income);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Income deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                registeredInComes.insert(incomeIndex, income);
              });
            }),
      ),
    );
*******************
        if (registeredInComes.isNotEmpty) {
      InComesMainContent = InComesList(
        income: registeredInComes,
        onRemoveInComes: _removeInComes,
      );
    }

    */