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
                      fontSize: 16.0,
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
                    height: 15,
                  ),
                  SizedBox(
                    width: 380,
                    height: 45,
                    child: TextField(
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
                      style: TextStyle(
                        color: Color(0xFF3E7C78),
                      ),
                      decoration: InputDecoration(
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
                ],
              ),

              //////
              Text("Hello"),
            ],
          ),
        ),
      ],
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
