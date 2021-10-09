import 'package:flutter/material.dart';

class RemoveScrollbar extends StatelessWidget {
  const RemoveScrollbar({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: child,
    );
  }
}
