import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  double income = 0.0;
  double expense = 0.0;
  bool showAllTransactions = false;
  bool showAllPeople = false;

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

  Future<void> _fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      userName = userDoc['username'] ?? 'Unknown User';
    });
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
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/log_background.png'),
              fit: BoxFit.contain,
              alignment: Alignment.topCenter),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Өглөөний мэнд?",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(height: 8),
                          Text(
                            userName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF2F7E79),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF2F7E79), width: 2),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Нийт үлдэгдэл",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_drop_up,
                                    color: Colors.white, size: 16),
                                Spacer(),
                                Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ],
                            ),
                            Text("\$${(income - expense).toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.arrow_upward,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text("Орлого",
                                        style: TextStyle(
                                          color: Color(0xFFD0E5E4),
                                          fontSize: 14,
                                        )),
                                  ],
                                ),
                                Text("\$${income.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.arrow_downward,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text("Зарлага",
                                        style: TextStyle(
                                          color: Color(0xFFD0E5E4),
                                          fontSize: 14,
                                        )),
                                  ],
                                ),
                                Text("\$${expense.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Гүйлгээний түүх",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAllTransactions = !showAllTransactions;
                      });
                    },
                    child: Text(
                      showAllTransactions ? "Хаах" : "Бүгдийг харах",
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _fetchTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No transactions found."));
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _calculateIncomeAndExpenses(snapshot.data!.docs);
                  });

                  return ListView.builder(
                    itemCount: showAllTransactions
                        ? snapshot.data!.docs.length
                        : snapshot.data!.docs.length > 4
                            ? 4
                            : snapshot.data!.docs.length,
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
                            // If the image doesn't exist, use the default.png
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Дахин илгээх",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAllPeople = !showAllPeople;
                      });
                    },
                    child: Text(
                      showAllPeople ? "Хаах" : "Бүгдийг харах",
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/images/persons/person${index + 1}.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF549994),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
