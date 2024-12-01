import 'package:flutter/material.dart';

class WalletThird extends StatefulWidget {
  final Function(int) onSwitch;

  WalletThird({required this.onSwitch});
  @override
  _WalletThirdState createState() => _WalletThirdState();
}

class _WalletThirdState extends State<WalletThird> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => widget.onSwitch(0), // Switch to WalletMain
            child: Text("Go to WalletMain"),
          ),
          ElevatedButton(
            onPressed: () => widget.onSwitch(2), // Switch to WalletThird
            child: Text("Go to Second"),
          ),
        ],
      ),
    );
  }
}
