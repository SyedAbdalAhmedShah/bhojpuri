import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../models/custom_video_model.dart';

class VideoCard extends StatelessWidget {
  final List<CustomVideoModal> videos;
  final int index;
  VideoCard({Key? key, required this.videos, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: videos[index].thumbnail ?? "",
          fit: BoxFit.fill,
          width: double.infinity,
          height: 28.h,
          placeholder: (context, url) => Center(child: CircularProgressIndicator.adaptive()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "${videos[index].videoTitle}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
