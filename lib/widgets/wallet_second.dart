import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//onPressed: () => widget.onSwitch(0),
//onPressed: () => widget.onSwitch(1),

class WalletSecond extends StatefulWidget {
  final Function(int) onSwitch;

  WalletSecond({required this.onSwitch});
  @override
  _WalletSecondState createState() => _WalletSecondState();
}

class _WalletSecondState extends State<WalletSecond>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? selectedOption;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  Future<void> addIncomeTransactionToFirebase() async {
    String message = '';
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      double amount = double.tryParse(amountController.text) ?? 0.0;

      await FirebaseFirestore.instance.collection('transactions').add({
        'cardName': nameController.text,
        'cardNumber': cardNumberController.text,
        'description': 'Орлого',
        'userId': userId,
        'amount': amount,
        'type': 'income',
        'timestamp': FieldValue.serverTimestamp(),
      });

      message = "Гүйлгээ амжилттай";
    } catch (error) {
      message = "Гүйлгээ амжилтгүй";
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
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              text: "Картууд",
            ),
            Tab(
              text: "Аккаунт",
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/logos/card.png',
                    width: 300,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Картны мэдээллээ нэмэх",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Энд холбох карт нь зөвхөн таны нэр дээр байх ёстой.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: 380,
                    height: 45,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(
                        color: Color(0xFF3E7C78),
                      ),
                      decoration: InputDecoration(
                          labelText: 'КАРТ ДЭЭРХ НЭР',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                            color: Color(0xFF3E7C78),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3E7C78)),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 380,
                    height: 45,
                    child: TextField(
                      controller: amountController,
                      style: TextStyle(
                        color: Color(0xFF3E7C78),
                      ),
                      decoration: InputDecoration(
                        prefixText: '\$',
                          labelText: 'Үнийн дүн',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                            color: Color(0xFF3E7C78),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3E7C78)),
                          )),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 380,
                    height: 45,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 240,
                          child: TextField(
                            controller: cardNumberController,
                            style: TextStyle(
                              color: Color(0xFF3E7C78),
                            ),
                            decoration: InputDecoration(
                                labelText: 'КАРТЫН ДУГААР',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF3E7C78)),
                                )),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: cvcController,
                            style: TextStyle(
                              color: Color(0xFF3E7C78),
                            ),
                            decoration: InputDecoration(
                                labelText: 'CVC',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF3E7C78)),
                                )),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            //keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 380,
                    height: 45,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 240,
                          child: TextField(
                            controller: expiryController,
                            style: TextStyle(
                              color: Color(0xFF3E7C78),
                            ),
                            decoration: InputDecoration(
                                labelText: 'ДУУСАХ ХУГАЦАА',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF3E7C78)),
                                )),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(7),
                              CardDateInputFormatter(),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: zipController,
                            style: TextStyle(
                              color: Color(0xFF3E7C78),
                            ),
                            decoration: InputDecoration(
                                labelText: 'ZIP',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(
                                  color: Color(0xFF3E7C78),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF3E7C78)),
                                )),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                        addIncomeTransactionToFirebase();
                      },
                      child: Text(
                        "Болсон",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF438883)),
                      ),
                    ),
                  ),
                ],
              ),

              //////

              ListView(
                padding: EdgeInsets.all(16),
                children: [
                  buildOptionCard(
                    optionKey: 'bank_link',
                    icon: Icons.account_balance,
                    title: 'Bank Link',
                    description: 'Connect your bank account to deposit & fund',
                  ),
                  buildOptionCard(
                    optionKey: 'microdeposits',
                    icon: Icons.attach_money,
                    title: 'Microdeposits',
                    description: 'Connect bank in 5-7 days',
                  ),
                  buildOptionCard(
                    optionKey: 'paypal',
                    icon: Icons.payment,
                    title: 'Paypal',
                    description: 'Connect your PayPal account',
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
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
                      onPressed: () {},
                      child: Text(
                        "Дараах",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF438883)),
                      ),
                    ),
                  ),
                ],
              ),

              ////
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOptionCard({
    required String optionKey,
    required IconData icon,
    required String title,
    required String description,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
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

class CardDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only digits and format to YYYY/MM
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length >= 5) {
      newText = '${newText.substring(0, 4)}/${newText.substring(4, 6)}';
    } else if (newText.length >= 3) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
