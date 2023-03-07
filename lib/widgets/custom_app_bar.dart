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
  FocusNode _searchNode = FocusNode();

  @override
  void initState() {
    _videoBloc = BlocProvider.of<VideoBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomGap(
          height: 5.h,
        ),
        Image(
          image: AssetImage(Assets.appName),
          // height: 8.h,
          width: 70.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomGap(
              width: 2.w,
            ),
            Expanded(
              child: TextFormField(
                focusNode: _searchNode,
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
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  suffixIcon: InkWell(
                      onTap: () {
                        if (_controller.text.isEmpty) {
                          _searchNode.requestFocus();
                        } else {
                          _videoBloc.add(SearchYtSongs(query: "${_controller.text} bhojpuri "));
                        }
                      },
                      child: Icon(Icons.search)),
                  border: InputBorder.none,
                ),
              ),
            ),
            // // InkWell(
            //   onTap: () {
            //     if (_controller.text.isEmpty && !_isExpanded) {
            //       _toggleExpand();
            //     } else {
            //       if (_controller.text.isEmpty) {
            //         _toggleExpand();
            //       } else {
            //         _videoBloc.add(SearchYtSongs(query: "${_controller.text} bhojpuri "));
            //       }
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 8.0),
            //     child: SizedBox(
            //       child: Center(child: Icon(Icons.search)),
            //     ),
            //   ),
            // ),
          ],
        ),
        Divider()
      ],
    );
  }
}
