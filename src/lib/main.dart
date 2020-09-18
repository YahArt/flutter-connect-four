import 'dart:math';

import 'package:flutter/material.dart';

main() => runApp(ConnectFourApp());

class ConnectFourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConnectFourWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConnectFourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.redo),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Connect Four',
          ),
        ),
      ),
      body: ConnectFourGameWidget(),
    );
  }
}

class ConnectFourGameWidget extends StatefulWidget {
  @override
  _ConnectFourGameWidgetState createState() => _ConnectFourGameWidgetState();
}

class _ConnectFourGameWidgetState extends State<ConnectFourGameWidget> {
  final int width = 7;
  final int height = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.yellow,
          child: Text(
            'Yellow has won',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.blue,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: width,
              children: List.generate(width * height, (index) {
                final colors = [Colors.yellow, Colors.lightBlue, Colors.red];
                final randomIndex = Random.secure().nextInt(colors.length);
                final color = colors[randomIndex];
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
