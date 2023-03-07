// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bojpuri/models/custom_video_model.dart';
import 'package:bojpuri/views/video_play_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:bojpuri/blocs/video_blocs/bloc/video_bloc_bloc.dart';
import 'package:bojpuri/utils/app_colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bojpuri/utils/assets.dart';
import 'package:bojpuri/widgets/custom_app_bar.dart';
import 'package:bojpuri/widgets/custom_gap.dart';

import '../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedChip = 0;

  TrackingScrollController trackingScrollController = TrackingScrollController();
  ScrollController _scrollController = ScrollController();
  List<CustomVideoModal>? _videos;
  List<CustomVideoModal>? _reels;
  List<CustomVideoModal>? firstVideo;
  late VideoBloc _videoBloc;
  String nextPageToken = '';
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();

  @override
  void initState() {
    _videoBloc = BlocProvider.of<VideoBloc>(context);

    _videoBloc.add(GetYoutubeVideos());
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.position.extentAfter == 0) {
          // setState(() {
          //   _isLoading = true;
          // });
          if (_videoBloc.state is! FetchingMoreVideoLoading) {
            _videoBloc.add(FetchMoreYoutubeVideos(nextPageToken: nextPageToken));
          }

          print("HIIIIII ");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _videoBloc,
      listener: (context, state) {
        print("video bloc state $state");
        if (state is YoutubeVideoState) {
          _videos = state.videos;
          firstVideo = state.firstVideo;
          _reels = state.reels;
          nextPageToken = state.nextPageToken;
        } else if (state is MiniPlayerLaunchedState) {
          _videos!.removeWhere((element) => element.videoId == state.videoDetail.videoId);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VideoPlayScreen(youtubeController: state.youtubeController, videoDetail: state.videoDetail, recomendationVideo: _videos!),
            ),
          );
        } else if (state is FetchedPaginatedYTVideos) {
          _videos!.addAll(state.moreVideos);
          nextPageToken = state.nextPageToken;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is VideoLoadingState,
          progressIndicator: CircularProgressIndicator.adaptive(),
          child: Scaffold(
            appBar: PreferredSize(child: CustomAppBar(), preferredSize: Size(double.infinity, kToolbarHeight + 4.h)),
            body: LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                Future.delayed(Duration(seconds: 1), () => _videoBloc.add(GetYoutubeVideos()));
              },
              showChildOpacityTransition: false,
              // showChild
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    if (firstVideo != null)
                      InkWell(
                        onTap: () => _videoBloc.add(PlayVideoEvent(video: _videos![0])),
                        child: VideoCard(
                          videos: firstVideo ?? [],
                          index: 0,
                        ),
                      ),
                    const CustomGap(),
                    SizedBox(
                      height: 22.h + 2.h + 24.sp,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) => InkWell(
                                onTap: () => _videoBloc.add(PlayVideoEvent(video: _reels![index])),
                                child: Reels(
                                  reelsVideo: _reels ?? [],
                                  index: index,
                                ),
                              ),
                          separatorBuilder: (_, index) => CustomGap(
                                height: 0,
                                width: 2.w,
                              ),
                          itemCount: _reels?.length ?? 0),
                    ),
                    CustomGap(),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) => InkWell(
                              onTap: () {
                                _videoBloc.add(PlayVideoEvent(video: _videos![index]));
                              },
                              child: VideoCard(
                                videos: _videos!,
                                index: index,
                              ),
                            ),
                        separatorBuilder: (_, index) => CustomGap(),
                        itemCount: _videos?.length ?? 0),
                    CustomGap(),
                    Visibility(visible: state is FetchingMoreVideoLoading, child: CircularProgressIndicator.adaptive()),
                    CustomGap(
                      height: 4.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Reels extends StatelessWidget {
  final List<CustomVideoModal> reelsVideo;
  final int index;
  const Reels({required this.reelsVideo, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: reelsVideo[index].thumbnail ?? "",
            fit: BoxFit.fill,
            height: 15.h + 2.h + 24.sp,
            width: 50.w,
            placeholder: (context, url) => Center(child: CircularProgressIndicator.adaptive()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              reelsVideo[index].description ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class VertDivider extends StatelessWidget {
  const VertDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.h,
      child: VerticalDivider(
        color: Colors.grey,
        width: 1,
        thickness: 1,
      ),
    );
  }
}
