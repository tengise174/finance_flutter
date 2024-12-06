import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/pages/onboarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This function streams transaction history in real-time
  Stream<List<Transaction>> fetchTransactionHistory() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('paymenthistory')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Transaction(
            transactionNumber: doc['transactionNumber'],
            amount: doc['amount'].toDouble(),
            date: doc['date'].toDate(),
          );
        }).toList();
      });
    } else {
      return Stream.value([]);
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<List<Transaction>>(
              stream: fetchTransactionHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No transactions found.'));
                }

                final transactions = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text('Гүйлгээний дугаар: ${transaction.transactionNumber}'),
                        subtitle: Text(
                            'Гүйлгээ дүн: \$${transaction.amount}\nОгноо: ${transaction.date}'),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final String transactionNumber;
  final double amount;
  final DateTime date;

  Transaction({
    required this.transactionNumber,
    required this.amount,
    required this.date,
  });
}
