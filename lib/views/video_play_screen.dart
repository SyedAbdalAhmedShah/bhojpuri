import 'dart:developer';

import 'package:bojpuri/blocs/video_blocs/bloc/video_bloc_bloc.dart';
import 'package:bojpuri/models/custom_video_model.dart';
import 'package:bojpuri/utils/strings.dart';
import 'package:bojpuri/widgets/custom_gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pod_player/pod_player.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../widgets/custom_app_bar.dart';

class VideoPlayScreen extends StatefulWidget {
  final PodPlayerController youtubeController;
  final CustomVideoModal videoDetail;
  final List<CustomVideoModal> recomendationVideo;
  const VideoPlayScreen({required this.youtubeController, required this.videoDetail, required this.recomendationVideo});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoBloc _videoBloc;
  late PodPlayerController _controller;

  @override
  void initState() {
    _controller = widget.youtubeController;

    _controller.initialise().then((value) => setState(() {
          _controller.play();
        }));

    _videoBloc = BlocProvider.of<VideoBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    widget.youtubeController.dispose();

    print("dispose called");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // CustomAppBar(),
            BlocListener(
              bloc: _videoBloc,
              listener: (context, state) {
                if (state is PlayVideo) {
                  _controller = state.youtubePlayerController;
                }
              },
              child: BlocBuilder(
                bloc: _videoBloc,
                builder: (context, state) {
                  return PodVideoPlayer(
                    controller: _controller,
                    videoThumbnail: _controller.isInitialised
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              widget.videoDetail.thumbnail ?? 'https://unsplash.com/photos/CiUR8zISX60',
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )
                        : null,
                  );
                },
              ),
            ),
            CustomGap(),
            Text(
              "${widget.videoDetail.videoTitle}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.black,
                    ),
                    Expanded(
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.8),
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            // childAspectRatio: 3.2 / 3,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () => _videoBloc.add(LoadVideo(videoModal: widget.recomendationVideo[index])),
                                child: Card(
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: widget.recomendationVideo[index].thumbnail!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 20.h,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Image.asset(Assets.poster),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          widget.recomendationVideo[index].description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black, fontSize: 10.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
