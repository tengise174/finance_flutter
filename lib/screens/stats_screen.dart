import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addExampleDataToFirebase(String userId) async {
  try {
    await FirebaseFirestore.instance.collection('transactions').add({
      'description': 'Youtube',
      'userId': userId,
      'amount': 500.00,
      'type': 'income', 
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('transactions').add({
      'description': 'Paypal',
      'userId': userId,
      'amount': 120.00,
      'type': 'expense', 
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('transactions').add({
      'description': 'Шилжүүлэг',
      'userId': userId,
      'amount': 250.00,
      'type': 'income',
      'timestamp': DateTime(2022, 1, 16),
    });

    await FirebaseFirestore.instance.collection('transactions').add({
      'description': 'Шилжүүлэг',
      'userId': userId,
      'amount': 200.00,
      'type': 'income',
      'timestamp': DateTime(2022, 1, 16),
    });

    print('Example data added successfully');
  } catch (e) {
    print('Error adding example data: $e');
  }
}


Future<void> addExampleOrderToFirebase(String userId) async {
  try {
    await FirebaseFirestore.instance.collection('orders').add({
      'description': 'Youtube',
      'userId': userId,
      'amount': 150.00,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('orders').add({
      'description': 'HouseRent',
      'userId': userId,
      'amount': 50.00,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print('Example orders added successfully');
  } catch (e) {
    print('Error adding example orders: $e');
  }
}

class StatsScreen extends StatefulWidget {
  final String userId;  
  StatsScreen({required this.userId});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  void _addData() {
    addExampleDataToFirebase(widget.userId);  
  }

  void _addOrder() {
    addExampleOrderToFirebase(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ElevatedButton(
          onPressed: _addData,
          child: Text("Add Example Data"),
        ),
        ElevatedButton(
          onPressed: _addOrder,
          child: Text("Add Example Order"),
        ),
        ],
      ),
    );
  }
}
