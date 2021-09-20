import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/utils/color/generate_material_color.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  accentColor: secondaryColor,
  scaffoldBackgroundColor: secondaryColor,
  primarySwatch: generateMaterialColor(greyColor),
);
