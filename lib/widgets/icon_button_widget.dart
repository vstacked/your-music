import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({Key? key, required this.icon, required this.color, required this.onPressed})
      : super(key: key);
  final Icon icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .75,
      child: IconButton(onPressed: onPressed, icon: icon, color: color, iconSize: 40, padding: const EdgeInsets.all(2)),
    );
  }
}
