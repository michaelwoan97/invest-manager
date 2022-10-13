import 'package:flutter/material.dart';
import 'package:invest_manager/styles/responsive/font_sizes.dart';

class AppTheme {
  static const kFontSizeMobileBodyText = TextStyle(fontSize: kMobileBodyText);
  static const kFontSizeDesktopBodyText = TextStyle(fontSize: kDesktopBodyText);
  static const kFontSizeMobileAppBarText = TextStyle(fontSize: kMobileSubHeadings);
  static const kFontSizeDesktopAppBarText = TextStyle(fontSize: kDesktopSubHeadings);

  static ThemeData get lightTheme {
    return ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey[50]);
  }

  static TextStyle displayInvenTitle(BuildContext context,final fontSize) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
      fontSize: fontSize
    );
  }

  static TextStyle totalInvenTitle(BuildContext ctx, Color titleColor,final fontSize){
    return Theme.of(ctx).textTheme.headlineSmall!.copyWith(
        fontSize: fontSize,
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
