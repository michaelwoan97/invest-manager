import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[50]);
  }

  static TextStyle displayInvenTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontSize: 20
    );
  }

  static TextStyle totalInvenTitle(BuildContext ctx, Color titleColor){
    return Theme.of(ctx).textTheme.headlineSmall!.copyWith(
        fontSize: 17,
        color: titleColor,
    );
  }


  static EdgeInsetsGeometry spaceBetweenSectionTop(){
    return const EdgeInsets.only(top: 30);
  }

  static EdgeInsetsGeometry spaceBetweenSectionBottom(){
    return const EdgeInsets.only(bottom: 30);
  }

  static EdgeInsetsGeometry spaceBetweenInListTop(){
    return const EdgeInsets.only(top: 5);
  }

  static EdgeInsetsGeometry spaceBetweenInListBottom(){
    return const EdgeInsets.only(bottom: 5);
  }

  static EdgeInsetsGeometry spaceBetweenInEList(){
    return const EdgeInsets.only(bottom: 3);
  }

  static double fontSizeDisplay(){
    double val = 20;
    return val;
  }
  static double cardElevation(){
    double val = 2;
    return val;
  }
}
