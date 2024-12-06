import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//widget.onSwitch(0),

class WalletThird extends StatefulWidget {
  final Function(int) onSwitch;

  WalletThird({required this.onSwitch});
  @override
  _WalletThirdState createState() => _WalletThirdState();
}

class _WalletThirdState extends State<WalletThird> {
  String? selectedItem;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  DateTime? pickedDate;

  Future<void> addExpenseTransactionToFirebase() async {
    String message = '';
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('orders').add({
        'description': selectedItem,
        'userId': userId,
        'amount': double.tryParse(_amountController.text) ?? 0.0,
        'timestamp': Timestamp.fromDate(pickedDate!),
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
                widget.onSwitch(0);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selected != null) {
      setState(() {
        pickedDate = selected;
        _dateController.text = "${selected.toLocal()}".split(' ')[0];
      });
    }
  }

  List<Map<String, String>> items = [
    {'image': 'assets/images/logos/netflix.png', 'text': 'Netflix'},
    {'image': 'assets/images/logos/youtube.png', 'text': 'Youtube'},
    {'image': 'assets/images/logos/spotify.png', 'text': 'Spotify'},
    {'image': 'assets/images/logos/electricity.png', 'text': 'Electricity'},
    {'image': 'assets/images/logos/houserent.png', 'text': 'HouseRent'},
    {'image': 'assets/images/logos/default.png', 'text': 'Зарлага'},
  ];

  @override
  void initState() {
    super.initState();
    selectedItem = items[0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Гүйлгээний нэр",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Color(0xFF438883)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: DropdownButton<String>(
                      value: selectedItem,
                      hint: Text('Select an item'),
                      items: items.map((item) {
                        return DropdownMenuItem<String>(
                            value: item['text'],
                            child: Container(
                              width: 320,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(item['image']!),
                                    radius: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item['text']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItem = newValue;
                        });
                      },
                      underline: SizedBox.shrink(),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Text(
                "Үнийн дүн",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 380,
                height: 60,
                child: TextField(
                  controller: _amountController,
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
                height: 30,
              ),
              Text(
                "Огноо",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Column(
                  children: [
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        hintText: 'Pick a date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Төлбөр",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 380,
                height: 50,
                child: DottedBorder(
                  color: Colors.black,
                  strokeWidth: 2,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () {
                        addExpenseTransactionToFirebase();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Төлбөр нэмэх",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
