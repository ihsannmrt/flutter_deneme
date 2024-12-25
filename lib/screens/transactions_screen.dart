import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class TransactionsScreen extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firebaseService.getTransactions('Income'), // 'Income' veya 'Expense'
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction['category']),
                subtitle: Text(transaction['description']),
                trailing: Text('${transaction['amount']}'),
              );
            },
          );
        },
      ),
    );
  }
}
