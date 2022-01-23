import 'package:flutter/material.dart';

class BoxContainer extends StatelessWidget {
  const BoxContainer({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(7))),
      margin: const EdgeInsets.all(6),
      height: 23,
      width: 80,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
