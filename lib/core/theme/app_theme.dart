import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  // Material Light Theme
  static final ThemeData lightMaterialTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
    ),
  );

  // Material Dark Theme
  static final ThemeData darkMaterialTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
    ),
  );

  // Cupertino Light Theme
  static final CupertinoThemeData lightCupertinoTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemBlue,
  );

  // Cupertino Dark Theme
  static final CupertinoThemeData darkCupertinoTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemBlue,
  );
}
