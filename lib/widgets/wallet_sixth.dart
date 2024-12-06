import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WalletSixth extends StatefulWidget {
  final Function(int) onSwitch;
  final String paymentMethod;
  final double amount;
  final String description;

  WalletSixth(
      {required this.onSwitch,
      required this.paymentMethod,
      required this.amount,
      required this.description});

  @override
  _WalletSixthState createState() => _WalletSixthState();
}

class _WalletSixthState extends State<WalletSixth> {
  late String transactionNumber;

  @override
  void initState() {
    super.initState();
    // Generate a 12-digit random transaction number
    transactionNumber = _generateTransactionNumber();
  }

  void shareReceipt() {
    saveTransactionToFirestore();
    widget.onSwitch(0);
  }

  String _generateTransactionNumber() {
    // Generate a 12-digit random number
    final random =
        (100000000000 + DateTime.now().millisecondsSinceEpoch % 1000000000000)
            .toString();
    return random;
  }

  Future<void> _copyTransactionNumber() async {
    await Clipboard.setData(ClipboardData(text: transactionNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Гүйлгээний дугаар хуулагдсан!')),
    );
  }

  Future<void> saveTransactionToFirestore() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    final transactionNumber = _generateTransactionNumber(); 
    final amount = widget.amount; 
    final transactionDate = DateTime.now(); 

    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('paymenthistory').add({
        'userId': userId,
        'transactionNumber': transactionNumber,
        'amount': amount*1.1,
        'date': transactionDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction saved!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save transaction: $e')));
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Амжилттай төлөгдлөө",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF438883),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          widget.description,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Icon(
          Icons.check_circle,
          color: Colors.teal,
          size: 24,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Гүйлгээний дэлгэрэнгүй",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.arrow_upward),
                ],
              ),
              SizedBox(
          height: 10,
        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Төлбөрийн хэрэгсэл",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.paymentMethod,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              SizedBox(
          height: 10,
        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Төлөв",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Хийгдсэн",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF438843),
                    ),
                  )
                ],
              ),
              SizedBox(
          height: 10,
        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Цаг",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              SizedBox(
          height: 10,
        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Огноо",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              SizedBox(
          height: 10,
        ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Гүйлгээний дугаар",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        transactionNumber,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: _copyTransactionNumber,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      top: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Үнэ",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "\$ ${widget.amount.toStringAsFixed(2)}",
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Хураамж",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "\$ ${(widget.amount * 0.1).toStringAsFixed(2)}",
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
                        "\$ ${(widget.amount * 1.1).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
          height: 10,
        ),
              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: QrImageView(
                  data: transactionNumber,
                  version: QrVersions.auto,
                  size: 100.0,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
          height: 30,
        ),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    shareReceipt();
                  },
                  child: Text(
                    "Илгээх",
                    style: TextStyle(fontSize: 20, color: Color(0xFF438883)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
