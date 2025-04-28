import 'package:flutter/material.dart';
 ThemeData lightTheme = ThemeData( 
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.black,
    error: Colors.red,
    scrim: Colors.grey,
  ),
 );

 ThemeData darkTheme = ThemeData( 
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Colors.black,
    secondary: Colors.white,
    error: Colors.red,
  ),
 );
