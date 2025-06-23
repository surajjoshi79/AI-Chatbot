import 'package:flutter/material.dart';

ThemeData lightMode=ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.black,
    tertiary: Color(0xFFbf9000)
  ),
  appBarTheme: AppBarTheme(
    color: Colors.grey.shade100
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: Colors.grey,
    selectionHandleColor: Colors.grey,
  )
);

ThemeData darkMode=ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.white,
      tertiary:Color(0xFFffe599),
    ),
    appBarTheme: AppBarTheme(
        color: Colors.grey.shade900
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.grey,
      selectionHandleColor: Colors.grey,
    )
);