import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Турийвч"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.teal,
            child: Column(
              children: [
                Text(
                  "Нийт үлдэгдэл",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "\$2,548.00",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.teal, size: 32),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.payment, color: Colors.teal, size: 32),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.teal, size: 32),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: "Гүйлгээ"),
                      Tab(text: "Хүлээгдэж буй"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(children: [/* Transactions */]),
                        ListView(children: [/* Pending Transactions */]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
