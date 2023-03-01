// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bojpuri/models/custom_video_model.dart';
import 'package:bojpuri/views/video_play_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:bojpuri/blocs/video_blocs/bloc/video_bloc_bloc.dart';
import 'package:bojpuri/utils/app_colors.dart';
import 'package:bojpuri/utils/assets.dart';
import 'package:bojpuri/widgets/custom_app_bar.dart';
import 'package:bojpuri/widgets/custom_gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  late YoutubePlayerController youtubeController;
  List<CustomVideoModal>? videos;
  late VideoBloc _videoBloc;
  bool _isLoading = false;

  @override
  void initState() {
    _videoBloc = BlocProvider.of<VideoBloc>(context);

    _videoBloc.add(GetYoutubeVideos());
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.position.extentAfter == 0) {
          setState(() {
            _isLoading = true;
          });
          // _videoBloc.add(FetchMoreYoutubeVideos(nextPageToken: videos?.nextPageToken ?? ""));
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
          videos = state.videos;
        } else if (state is MiniPlayerLaunchedState) {
          videos!.removeWhere((element) => element.videoId == state.videoDetail.videoId);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VideoPlayScreen(
                  youtubeController: state.youtubeController,
                  videoDetail: state.videoDetail,
                  recomendationVideo: videos!),
            ),
          );
        } else if (state is FetchedPaginatedYTVideos) {
          // videos?.thumbnail?.addAll(state.moreVideos.thumbnail ?? []);
          // videos?.videoId?.addAll(state.moreVideos.videoId ?? []);
          // videos?.videoTitle?.addAll(state.moreVideos.videoTitle ?? []);
          // videos?.nextPageToken = state.moreVideos.nextPageToken;
          // videos = CustomVideoModal(thumbnail: videos?.thumbnail?.toSet().toList(), videoId: videos?.videoId?.toSet().toList(), videoTitle: videos?.videoTitle?.toSet().toList());
          // _isLoading = false;
          // setState(() {});
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: PreferredSize(preferredSize: Size(double.infinity, kToolbarHeight + 2.h), child: CustomAppBar()),
              body: state is VideoLoadingState
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.home_outlined,
                                  size: 4.h,
                                ),
                              ),
                              VertDivider(),
                              CustomGap(
                                height: 0,
                                width: 1.w,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 4.h,
                                  child: ListView.separated(
                                      // physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (_, index) => ChoiceChip(
                                            onSelected: (selected) {
                                              setState(() {
                                                selectedChip = index;
                                              });
                                            },
                                            backgroundColor: AppColors.chipUnselectedColr,
                                            side: BorderSide(color: Colors.transparent),
                                            label: Text('Category'),
                                            selected: selectedChip == index ? true : false,
                                            selectedColor: AppColors.chipSelectedColr,
                                          ),
                                      separatorBuilder: (_, index) => CustomGap(
                                            height: 0,
                                            width: 1.w,
                                          ),
                                      itemCount: 10),
                                ),
                              )
                            ],
                          ),
                          const CustomGap(),
                          // VideoCard(
                          //   bloc: _videoBloc,
                          // ),
                          // const CustomGap(),
                          // SizedBox(
                          //   height: 15.h + 2.h + 24.sp,
                          //   child: ListView.separated(
                          //       scrollDirection: Axis.horizontal,
                          //       itemBuilder: (_, index) => Reels(),
                          //       separatorBuilder: (_, index) => CustomGap(
                          //             height: 0,
                          //             width: 2.w,
                          //           ),
                          //       itemCount: 10),
                          // ),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) => InkWell(
                                    onTap: () {
                                      _videoBloc.add(PlayVideoEvent(video: videos![index]));
                                    },
                                    child: VideoCard(
                                      videos: videos!,
                                      index: index,
                                    ),
                                  ),
                              separatorBuilder: (_, index) => CustomGap(),
                              itemCount: videos?.length ?? 0),

                          Visibility(
                              visible: _isLoading,
                              child: SizedBox(height: 20, child: CircularProgressIndicator.adaptive()))
                        ],
                      ),
                    ),
            ),
            // NotificationListener(
            //   onNotification: (notifier) {
            //     print("notification $notifier");
            //     return true;
            //   },
            //   child: BlocBuilder(
            //     bloc: _videoBloc,
            //     builder: (context, state) {
            //       print("builder state is $state ");
            //       return Visibility(
            //         visible: state is MiniPlayerLaunchedState,
            //         child: Miniplayer(
            //             minHeight: 100,
            //             onDismiss: () {
            //               print('object');
            //             },
            //             controller: _videoBloc.miniplayerController,
            //             maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            //             builder: (height, percentage) => Container(
            //                   color: Colors.teal,
            //                   child: Column(
            //                     // controller: _scrollController,
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       YoutubePlayer(
            //                         bufferIndicator: LinearProgressIndicator(
            //                           color: AppColors.secondaryColor,
            //                         ),
            //                         controller: youtubeController,
            //                         width: height > 100 ? height : height + 50,
            //                         showVideoProgressIndicator: true,
            //                         progressColors: ProgressBarColors(playedColor: AppColors.primaryColor, handleColor: AppColors.primaryColor, bufferedColor: AppColors.secondaryColor),
            //                       ),
            //                       CustomGap(),
            //                     ],
            //                   ),
            //                 )),
            //       );
            //     },
            //   ),
            // )
          ],
        );
      },
    );
  }
}

class Reels extends StatelessWidget {
  const Reels({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 15.h,
          width: 50.w,
          decoration: BoxDecoration(
              color: Colors.teal, image: DecorationImage(image: AssetImage(Assets.poster), fit: BoxFit.fill)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Description",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
          ),
        ),
      ],
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
