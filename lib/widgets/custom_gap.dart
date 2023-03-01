import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class CustomGap extends StatelessWidget {
  final double? height;
  final double? width;

  const CustomGap({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 2.h,
      width: width,
    );
  }
}
