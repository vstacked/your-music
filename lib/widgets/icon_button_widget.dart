import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isOutlinedButton = false,
    this.buttonText = '',
    this.iconSize = 35,
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onPressed;
  final Color color;
  final bool isOutlinedButton;
  final String buttonText;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (isOutlinedButton) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Text(buttonText),
        label: icon,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(color),
          side: MaterialStateProperty.all(BorderSide(color: color)),
          fixedSize: MaterialStateProperty.all(const Size.fromHeight(47.5)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.titleMedium),
        ),
      );
    }

    return IconButton(onPressed: onPressed, icon: icon, color: color, iconSize: iconSize, splashRadius: 30);
  }
}
