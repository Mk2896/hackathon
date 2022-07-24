import 'package:flutter/material.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget({
    Key? key,
    required this.color,
    required this.isSelected,
  }) : super(key: key);

  final Color color;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? Colors.black : Colors.transparent),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
