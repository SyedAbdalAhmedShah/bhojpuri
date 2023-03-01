import 'package:bojpuri/utils/app_colors.dart';
import 'package:bojpuri/utils/strings.dart';
import 'package:bojpuri/widgets/custom_gap.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/assets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image(
            image: AssetImage(Assets.logoImage),
            height: 5.h,
          ),
          CustomGap(
            height: 0,
            width: 2.w,
          ),
          Text(Strings.bhojpuri, style: Theme.of(context).textTheme.titleMedium),
          CustomGap(
            height: 0,
            width: 2.w,
          ),
          Text(Strings.videosCom,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.secondaryColor)),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          onPressed: () {},
        )
      ],
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, 1.h),
        child: Divider(
          thickness: 0.2.h,
        ),
      ),
    );
  }
}
