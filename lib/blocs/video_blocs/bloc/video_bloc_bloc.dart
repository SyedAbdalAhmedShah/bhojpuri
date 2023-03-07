import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bojpuri/models/custom_video_model.dart';
import 'package:bojpuri/utils/strings.dart';
import 'package:meta/meta.dart';
import 'package:pod_player/pod_player.dart';

import '../../../functions/video_repo.dart';

part 'video_bloc_event.dart';
part 'video_bloc_state.dart';

class VideoBloc extends Bloc<VideoBlocEvent, VideoBlocState> {
  bool controllerInitialized = false;
  VideoRepository videoRepository = VideoRepository();
  PodPlayerController? controller;
  VideoBloc() : super(VideoBlocInitial()) {
    on<PlayVideoEvent>((event, emit) async {
      emit(VideoLoadingState());
      try {
        print('hiiiii ${event.video.videoId}');
        controller = PodPlayerController(
          playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${event.video.videoId}'),
          podPlayerConfig: const PodPlayerConfig(
            autoPlay: false,
            isLooping: false,
            videoQualityPriority: [720, 360],
          ),
        );

        emit(MiniPlayerLaunchedState(
          youtubeController: controller!,
          videoDetail: event.video,
        ));
      } catch (error) {
        print("error exsits $error");
      }
    });
    on<GetYoutubeVideos>((event, emit) async {
      emit(VideoLoadingState());
      try {
        Map mapData = await videoRepository.getTheYTVideos(searchQuery: Strings.staticYtQuery);
        List<CustomVideoModal> allVideos = mapData[1];
        String nextPageToken = mapData[2];

        List<CustomVideoModal> reels = [];
        List<CustomVideoModal> firstVideo = [];

        for (var i = 0; i <= 9; i++) {
          print(i);

          reels.add(allVideos.removeAt(i));
        }
        firstVideo.add(allVideos.removeAt(0));
        print('allvideos length ==============> ${allVideos.length}');
        print('Reels length ==============> ${reels.length}');
        print('token next page  ==============> $nextPageToken');
        emit(YoutubeVideoState(videos: allVideos, reels: reels, nextPageToken: nextPageToken, firstVideo: firstVideo));
      } catch (error) {
        print('Error $error');
      }
    });

    on<FetchMoreYoutubeVideos>((event, emit) async {
      try {
        emit(FetchingMoreVideoLoading());
        print('i am trigger');
        print('next page token ${event.nextPageToken}');
        Map mapData = await videoRepository.getTheYTVideos(nextPageToken: event.nextPageToken, searchQuery: Strings.staticYtQuery);
        List<CustomVideoModal> allVideos = mapData[1];
        String nextPageToken = mapData[2];
        emit(FetchedPaginatedYTVideos(nextPageToken: nextPageToken, moreVideos: allVideos));
      } catch (error) {
        print('error occure during fetch more videos $error');
      }
    });
    on<LoadVideo>((event, emit) {
      try {
        controller!.changeVideo(playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${event.videoModal.videoId}'));
        emit(PlayVideo(youtubePlayerController: controller!));
      } catch (error) {
        log('error occure in load video event $error');
      }
    });
    on<SearchYtSongs>((event, emit) async {
      emit(VideoLoadingState());
      try {
        log('query is ${event.query}');
        Map mapData = await videoRepository.getTheYTVideos(searchQuery: event.query);
        List<CustomVideoModal> allVideos = mapData[1];
        String nextPageToken = mapData[2];
        List<CustomVideoModal> reels = [];
        List<CustomVideoModal> firstVideo = [];
        for (var i = 0; i <= 9; i++) {
          print(i);

          reels.add(allVideos.removeAt(i));
        }
        print('allvideos length ==============> ${allVideos.length}');
        print('Reels length ==============> ${reels.length}');
        print('token next page  ==============> $nextPageToken');
        firstVideo.add(allVideos.removeAt(0));
        emit(YoutubeVideoState(videos: allVideos, nextPageToken: nextPageToken, reels: reels, firstVideo: firstVideo));
      } catch (error) {
        log('Error occure in search song event $error');
      }
    });
  }
}
