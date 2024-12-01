import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletMain extends StatefulWidget {
  final Function(int) onSwitch;

  WalletMain({required this.onSwitch});
  @override
  _WalletMainState createState() => _WalletMainState();
}

class _WalletMainState extends State<WalletMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double income = 0.0;
  double expense = 0.0;

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

  Stream<QuerySnapshot> _fetchTransactions() {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((error) {
      print("Error fetching transactions: $error");
    });
  }

  void _calculateIncomeAndExpenses(List<DocumentSnapshot> transactions) {
    double newIncome = 0.0;
    double newExpense = 0.0;

    for (var transaction in transactions) {
      double amount = transaction['amount'] ?? 0.0;
      String type = transaction['type'] ?? '';
      if (type == 'income') {
        newIncome += amount;
      } else if (type == 'expense') {
        newExpense += amount;
      }
    }

    if (newIncome != income || newExpense != expense) {
      setState(() {
        income = newIncome;
        expense = newExpense;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Stream<QuerySnapshot> _fetchOrders() {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((error) {
      print("Error fetching orders: $error");
    });
  }

  void showPaymentDialog({
    required BuildContext context,
    required String description,
    required double amount,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Төлбөрийн дэлгэрэнгүй',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Төлбөр нэр: $description'),
              const SizedBox(height: 8),
              Text('Үнийн дүн: \$${amount.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                print(
                    'Payment confirmed for $description, ₮${amount.toStringAsFixed(2)}');
              },
              child: const Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40),
        Text(
          "Нийт үлдэгдэл",
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 13,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "\$${(income - expense).toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => widget.onSwitch(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF2F7E79), width: 1),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Color(0xFF2F7E79),
                      size: 35,
                    ),
                  ),
                  Text("Нэмэх", style: TextStyle(color: Colors.black))
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => widget.onSwitch(2),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF2F7E79), width: 1),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Icon(
                      Icons.qr_code,
                      color: Color(0xFF2F7E79),
                      size: 35,
                    ),
                  ),
                  Text("Төлөх", style: TextStyle(color: Colors.black))
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF2F7E79), width: 1),
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Color(0xFF2F7E79),
                      size: 35,
                    ),
                  ),
                  Text("Илгээх", style: TextStyle(color: Colors.black))
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
        TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF2F7E79),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0),
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF2F7E79),
                width: 2.0,
              ),
            ),
          ),
          tabs: [
            Tab(
              text: "Гүйлгээ",
            ),
            Tab(
              text: "Захиалга",
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _fetchTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Гүйлгээ байхгүй байна."));
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _calculateIncomeAndExpenses(snapshot.data!.docs);
                  });

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var transaction = snapshot.data!.docs[index];
                      String description = transaction['description'] ?? '';
                      double amount = transaction['amount'] ?? 0.0;
                      String type = transaction['type'] ?? '';
                      Timestamp timestamp = transaction['timestamp'];
                      String formattedDate = formatDate(timestamp);

                      String descriptionLower = description.toLowerCase();
                      String imagePath =
                          'assets/images/logos/$descriptionLower.png';

                      return ListTile(
                        leading: Image.asset(
                          imagePath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/logos/default.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        title: Text(description),
                        subtitle: Text(formattedDate),
                        trailing: Text(
                          "${type == 'income' ? '+' : '-'}\$${amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: type == 'income'
                                ? Color(0xFF25A969)
                                : Color(0xFFF95B51),
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No orders found."));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data!.docs[index];
                      String description = order['description'] ?? '';
                      double amount = order['amount'] ?? 0.0;
                      Timestamp timestamp = order['timestamp'];
                      String formattedDate = formatDate(timestamp);
                      String descriptionLower = description.toLowerCase();
                      String imagePath =
                          'assets/images/logos/$descriptionLower.png';
                      return ListTile(
                        leading: Image.asset(
                          imagePath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/logos/default.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        title: Text(description),
                        subtitle: Text(formattedDate),
                        trailing: TextButton(
                            onPressed: () {
                              showPaymentDialog(
                                context: context,
                                description: description,
                                amount: amount,
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFFECF9F8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                  color: Color(0xFFECF9F8), width: 1),
                            ),
                            child: Text(
                              "Төлөх",
                              style: TextStyle(
                                color: Color(0xFF438883),
                              ),
                            )),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
