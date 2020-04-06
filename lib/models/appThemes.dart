import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // static Color _iconColor = Colors.blueAccent.shade200;
  static Color _appBarColor = Colors.transparent;

  static const Color _lightPrimarySwatch = Colors.blue;
  static const Color _lightAccentColor = Colors.blueAccent;
  // static const Color _lightPrimaryColor = Colors.white;
  static const Color _lightPrimaryVariantColor = Color(0XFFE1E1E1);
  // static const Color _lightSecondaryColor = Colors.green;
  static const Color _lightOnPrimaryColor = Colors.black;

  static const Color _darkPrimarySwatch = Colors.red;
  static const Color _darkAccentColor = Colors.redAccent;
  // static const Color _darkPrimaryColor = Colors.white24;
  static const Color _darkPrimaryVariantColor = Colors.black;
  // static const Color _darkSecondaryColor = Colors.white;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final TextStyle _lightScreenHeadingTextStyle =
      TextStyle(color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskNameTextStyle =
      TextStyle(color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(color: Colors.grey);

  static final TextStyle _darkScreenHeadingTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenTaskNameTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenTaskDurationTextStyle;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightPrimaryVariantColor,
    fontFamily: 'Raleway',
    primarySwatch: _lightPrimarySwatch,
    accentColor: _lightAccentColor,
    appBarTheme: AppBarTheme(
      color: _appBarColor,
      iconTheme: IconThemeData(color: _lightOnPrimaryColor),
    ),
    // colorScheme: ColorScheme.light(
    //   primary: _lightPrimaryColor,
    //   primaryVariant: _lightPrimaryVariantColor,
    //   secondary: _lightSecondaryColor,
    //   onPrimary: _lightOnPrimaryColor,
    // ),
    iconTheme: IconThemeData(
      color: _lightOnPrimaryColor,
    ),
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkPrimaryVariantColor,
    primarySwatch: _darkPrimarySwatch,
    accentColor: _darkAccentColor,
    fontFamily: 'Raleway',
    appBarTheme: AppBarTheme(
      color: _appBarColor,
      iconTheme: IconThemeData(color: _darkOnPrimaryColor),
    ),
    // colorScheme: ColorScheme.light(
    //   primary: _darkPrimaryColor,
    //   primaryVariant: _darkPrimaryVariantColor,
    //   secondary: _darkSecondaryColor,
    //   onPrimary: _darkOnPrimaryColor,
    // ),
    iconTheme: IconThemeData(
      color: _darkOnPrimaryColor,
    ),
    textTheme: _darkTextTheme,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    headline5: _lightScreenHeadingTextStyle,
    bodyText2: _lightScreenTaskNameTextStyle,
    bodyText1: _lightScreenTaskDurationTextStyle,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline5: _darkScreenHeadingTextStyle,
    bodyText2: _darkScreenTaskNameTextStyle,
    bodyText1: _darkScreenTaskDurationTextStyle,
  );
}