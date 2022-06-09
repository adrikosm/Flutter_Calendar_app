import 'package:flutter/material.dart';
import 'package:task_1/utils/colors_util.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onTap;

  const MyButton({Key key, this.label, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: HexColor('#2E86C1'),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
