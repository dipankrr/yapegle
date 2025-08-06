import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  final String text;
  final IconData? icon;
  final bool iconAfterText; // 👈 New parameter
  final VoidCallback onTap;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.width = 150,
    this.height = 50,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.textSize = 20,
    this.icon,
    this.iconAfterText = false, // 👈 Default: icon before text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (icon != null && !iconAfterText) {
      children.add(Icon(icon, color: textColor));
      children.add(const SizedBox(width: 8));
    }

    children.add(
      Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
        ),
      ),
    );

    if (icon != null && iconAfterText) {
      children.add(const SizedBox(width: 8));
      children.add(Icon(icon, color: textColor));
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, height),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

