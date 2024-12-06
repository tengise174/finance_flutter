import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> addExampleDataToFirebase(String userId) async {
  await FirebaseFirestore.instance.collection('orders').doc("8RptGsc66YIfYYyh987w").delete();
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
