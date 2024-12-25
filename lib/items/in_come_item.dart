import 'package:flutter_deneme/models/in_come.dart';
import 'package:flutter/material.dart';

class InComeItem extends StatelessWidget {
  const InComeItem(this.income, this.dateFormatter, {super.key});

  final InCome income;
  final String Function(DateTime date) dateFormatter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            children: [
              Text(
                income.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '₺${income.amount.toStringAsFixed(2)}',
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Tarih burada formatlanmış olarak gösteriliyor
                      Text(dateFormatter(income.date)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
