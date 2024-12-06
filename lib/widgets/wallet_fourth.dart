import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletFourth extends StatefulWidget {
  final Function(int) onSwitch;
  final String orderId;
  final Function(String) setPaymentMethod;

  WalletFourth({required this.onSwitch, required this.orderId, required this.setPaymentMethod});
  @override
  _WalletFourthState createState() => _WalletFourthState();
}

class _WalletFourthState extends State<WalletFourth> {
  String description = '';
  double amount = 0;
  String formattedDate = '';
  late Timestamp timestamp;
  bool isLoading = true;

  String selectedOption = 'Дебит карт';

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
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
          Timestamp timestamp = orderData['timestamp'] ?? Timestamp.now();
          formattedDate = formatDate(timestamp);
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

  Widget build(BuildContext context) {
    String descriptionLower = description.toLowerCase();
    String imagePath = 'assets/images/logos/$descriptionLower.png';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                ListTile(
                  leading: Image.asset(
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
                  title: Text(
                    description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(formattedDate),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                SizedBox(height: 40,),
                Column(
                  children: [
                    Text("Төлбөрийн хэрэгслээ сонго",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),),
                    SizedBox(height: 10,),
                    buildOptionCard(
                      optionKey: 'Дебит карт',
                      icon: Icons.credit_card,
                      title: 'debitcard',
                    ),
                    buildOptionCard(
                      optionKey: 'Paypal',
                      icon: Icons.attach_money,
                      title: 'Paypal',
                    ),
                  ],
                ),
                SizedBox(height: 30,),
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
                          WidgetStateProperty.all(Color(0xFF438883)),
                      elevation: WidgetStateProperty.all(0),
                    ),
                    onPressed: () {
                      widget.onSwitch(4);
                      widget.setPaymentMethod(selectedOption);
                    },
                    child: Text(
                      "Төлөх",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return "Өнөөдөр";
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return "Өчигдөр";
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  Widget buildOptionCard({
    required String optionKey,
    required IconData icon,
    required String title,
  }) {
    bool isSelected = selectedOption == optionKey;
    Color textColor = isSelected ? Colors.teal : Colors.grey;
    Color iconColor = isSelected ? Colors.teal : Colors.grey;
    Color backgroundColor = isSelected ? Colors.teal[50]! : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = optionKey;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 100,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.teal,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
