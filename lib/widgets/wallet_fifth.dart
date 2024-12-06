import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletFifth extends StatefulWidget {
  final Function(int) onSwitch;
  final String orderId;
  final Function(double) setAmount;
  final Function(String) setDescription;

  WalletFifth({required this.onSwitch, required this.orderId, required this.setAmount, required this.setDescription});

  @override
  _WalletFifthState createState() => _WalletFifthState();
}

class _WalletFifthState extends State<WalletFifth> {
  String description = '';
  double amount = 0;
  Timestamp timestamp = Timestamp.now();
  bool isLoading = true;
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
  }

  Future<void> payOrderPayment() async {
    widget.setAmount(amount);
    widget.setDescription(description);
    String message = '';
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .delete();
      await FirebaseFirestore.instance.collection('transactions').add({
        'description': description,
        'userId': userId,
        'amount': amount * 1.1,
        'type': 'expense',
        'timestamp': timestamp,
      });
      message = "Гүйлгээ амжилттай";
    } catch (e) {
      message = "Гүйлгээ амжилтгүй";
      print(e);
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Төлөв',
            style: TextStyle(color: Color(0xFF438883)),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onSwitch(5);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _fetchOrderData() async {
    try {
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;
        setState(() {
          description = orderData['description'] ?? '';
          amount = orderData['amount']?.toDouble() ?? 0.0;
          timestamp = orderData['timestamp'] ?? Timestamp.now();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching order: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String descriptionLower = description.toLowerCase();
    String imagePath = 'assets/images/logos/$descriptionLower.png';

    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logos/default.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 18),
                          children: [
                            TextSpan(
                              text: 'You will pay ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: '$description',
                              style: TextStyle(color: Color(0xFF438883)),
                            ),
                            TextSpan(
                              text: ' for one month with BCA OneKlik',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Үнэ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$ ${amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Хураамж",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$ ${(amount * 0.1).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Нийт",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "\$ ${(amount * 1.1).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 280,),
                    Container(
                      width: 380,
                      decoration: BoxDecoration(
                        color: Color(0xFF3F8782),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Color(0xFF438883)),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {
                          payOrderPayment();
                        },
                        child: Text(
                          "Баталгаажуулах",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
