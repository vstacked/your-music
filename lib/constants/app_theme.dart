import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/utils/color/generate_material_color.dart';

ThemeData buildTheme() {
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

  return darkTheme.copyWith(textTheme: GoogleFonts.robotoTextTheme(darkTheme.textTheme));
}
