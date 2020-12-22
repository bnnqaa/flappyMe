import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final size;

  MyBarrier({this.size, this.xPos, this.yPos});
  double xPos, yPos;

  void setX(double x) {
    xPos = x;
  }

  double get x => xPos;

  void setY(double y) {
    yPos = y;
  }

  double get y => yPos;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          width: 02,
          color: Colors.green[700],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
