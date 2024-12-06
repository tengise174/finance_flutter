import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/screens/home_screen.dart';
import 'package:finance_app/widgets/wallet_fifth.dart';
import 'package:finance_app/widgets/wallet_fourth.dart';
import 'package:finance_app/widgets/wallet_main.dart';
import 'package:finance_app/widgets/wallet_sixth.dart';
import 'package:finance_app/widgets/wallet_third.dart';
import 'package:finance_app/widgets/wallet_second.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  int currentScreenIndex = 0;
  String orderId = '';
  String paymentMethod = '';
  double amount = 0;
  String description = '';

  void setDescription(String newDescription) {
    setState(() {
      description = newDescription;
    });
  }

  void setAmount(double newAmount) {
    setState(() {
      amount = newAmount;
    });
  }

  void setOrderId(String newOrderid) {
    setState(() {
      orderId = newOrderid;
    });
  }

  void setPaymentMethod(String newPaymentMethod) {
    setState(() {
      paymentMethod = newPaymentMethod;
    });
  }

  void switchScreen(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      WalletMain(onSwitch: switchScreen, setOrderId: setOrderId),
      WalletSecond(onSwitch: switchScreen),
      WalletThird(onSwitch: switchScreen),
      WalletFourth(onSwitch: switchScreen, setPaymentMethod: setPaymentMethod ,orderId: orderId),
      WalletFifth(onSwitch: switchScreen, orderId: orderId, setAmount: setAmount, setDescription: setDescription),
      WalletSixth(onSwitch: switchScreen, paymentMethod: paymentMethod, amount: amount, description: description),
    ];

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
            SizedBox(height: 70),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentScreenIndex = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentScreenIndex == 0
                        ? "Түрийвч"
                        : currentScreenIndex == 1
                            ? "Түрийвч цэнэглэх"
                            : currentScreenIndex == 2
                                ? "Зарлага нэмэх"
                                : "",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
///////
                child: screens[currentScreenIndex],
//////////
              ),
            ),
          ],
        ),
      ),
    );
  }
}
