import 'package:flutter_deneme/items/in_come_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deneme/models/in_come.dart';

class InComesList extends StatelessWidget {
  const InComesList({
    super.key,
    required this.income,
    required this.onRemoveInComes,
    required this.dateFormatter, // Burada dateFormatter parametresini ekliyoruz
  });

  final List<InCome> income;
  final void Function(InCome income) onRemoveInComes;
  final String Function(DateTime date) dateFormatter; // dateFormatter parametresinin tipi

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: income.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) {
          onRemoveInComes(income[index]);
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
        key: ValueKey(income[index]),
        child: InComeItem(
          income[index],
          dateFormatter, // Burada dateFormatter parametresini geçiriyoruz
        ),
      ),
    );
  }
}
