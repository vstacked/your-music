import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/utils/color/generate_material_color.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  hintColor: secondaryColor,
  scaffoldBackgroundColor: secondaryColor,
  checkboxTheme: CheckboxThemeData(
    side: const BorderSide(color: redColor, width: 2),
    checkColor: MaterialStateProperty.all(redColor),
    fillColor: MaterialStateProperty.all(Colors.white),
  ),
  primarySwatch: generateMaterialColor(greyColor),
);
