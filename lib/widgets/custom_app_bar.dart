import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:bojpuri/blocs/video_blocs/bloc/video_bloc_bloc.dart';
import 'package:bojpuri/utils/app_colors.dart';
import 'package:bojpuri/utils/strings.dart';
import 'package:bojpuri/widgets/custom_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../utils/assets.dart';

class CustomAppBar extends StatefulWidget {
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late VideoBloc _videoBloc;
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    _videoBloc = BlocProvider.of<VideoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          CustomGap(
            height: 3.h,
          ),
          Row(
            children: [
              Image(
                image: AssetImage(Assets.logoImage),
                height: 5.h,
              ),
              Image(
                image: AssetImage(Assets.appName),
                height: 15.h,
              ),
              CustomGap(
                height: 0,
                width: 2.w,
              ),
              // Text(Strings.bhojpuri, style: Theme.of(context).textTheme.titleMedium),
              // CustomGap(
              //   height: 0,
              //   width: 2.w,
              // ),
              // Text(Strings.videosCom, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.secondaryColor)),
              // // Spacer(),

              CustomGap(
                height: 0,
                width: 1.w,
              ),
              Spacer(),

              //     Expanded(
              //       child: AnimatedSearchBar(
              //         searchDecoration: InputDecoration(border: UnderlineInputBorder(), hintText: "search"),

              //         onChanged: (value) {
              //           print("value on Change $value");
              //           // setState(() {
              //           //   searchText = value;
              //           // });
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _toggleExpand,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.topLeft,
                  width: _isExpanded ? 60.w : 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomGap(
                        width: 2.w,
                      ),
                      _isExpanded
                          ? Expanded(
                              child: TextFormField(
                                controller: _controller,
                                onFieldSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _videoBloc.add(SearchYtSongs(query: "${value} bhojpuri "));
                                    _controller.clear();
                                  } else {
                                    setState(() {
                                      _isExpanded = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(fontSize: 8.sp),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      InkWell(
                        onTap: () {
                          if (_controller.text.isEmpty && !_isExpanded) {
                            _toggleExpand();
                          } else {
                            if (_controller.text.isEmpty) {
                              _toggleExpand();
                            } else {
                              _videoBloc.add(SearchYtSongs(query: "${_controller.text} bhojpuri "));
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            child: Center(child: Icon(Icons.search)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
