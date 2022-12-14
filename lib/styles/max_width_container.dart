import 'package:flutter/material.dart';
import 'package:invest_manager/styles/responsive/breakpoints.dart';

/*
* class: MaxWidthContainer
* purpose: This class used for when the tablet/desktop breakpoint was reached
*           the layout from the class will be used
* */
class MaxWidthContainer extends StatelessWidget {
  final Widget child;

  const MaxWidthContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxWidth),
        child: child,
      ),
    );
  }
}
