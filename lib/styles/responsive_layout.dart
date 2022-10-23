import 'package:flutter/material.dart';
import 'package:invest_manager/styles/responsive/breakpoints.dart';


/*
* class: ResponsiveLayout
* purpose: create responsive layouts
* */
class ResponsiveLayout extends StatelessWidget {
  ResponsiveLayout(
      {Key? key, required this.mobileBody, tabletVersion, desktopVersion}) {
    tabletBody = tabletVersion ?? mobileBody;
    desktopBody = desktopVersion ?? mobileBody;
  }

  final Widget mobileBody;
  late Widget tabletBody;
  late Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, dimens) {
      if (dimens.maxWidth < kTabletBreakPoint) {
        return mobileBody;
      } else if (dimens.maxWidth >= kTabletBreakPoint &&
          dimens.maxWidth < kDesktopBreakPoint) {
        return tabletBody ?? mobileBody;
      } else {
        return desktopBody ?? mobileBody;
      }
    });
  }
}
