import 'package:bloc/bloc.dart';
import 'package:bojpuri/models/custom_video_model.dart';
import 'package:meta/meta.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../functions/video_repo.dart';

part 'video_bloc_event.dart';
part 'video_bloc_state.dart';

class VideoBloc extends Bloc<VideoBlocEvent, VideoBlocState> {
  MiniplayerController miniplayerController = MiniplayerController();
  bool controllerInitialized = false;
  VideoRepository videoRepository = VideoRepository();
  late YoutubePlayerController youtubeController;
  VideoBloc() : super(VideoBlocInitial()) {
    on<PlayVideoEvent>((event, emit) async {
      emit(VideoPlayingLoadingState());
      try {
        youtubeController = YoutubePlayerController(
          initialVideoId: event.video.videoId ?? "",
          flags: YoutubePlayerFlags(autoPlay: true, controlsVisibleAtStart: true),
        );

        miniplayerController.animateToHeight(state: PanelState.MAX);

        youtubeController.play();
        emit(MiniPlayerLaunchedState(
            youtubeController: youtubeController,
            miniplayerController: miniplayerController,
            videoDetail: event.video));
      } catch (error) {
        print("error exsits $error");
      }
    });
    on<GetYoutubeVideos>((event, emit) async {
      emit(VideoLoadingState());
      try {
        Map mapData = await videoRepository.getTheYTVideos();
        List<CustomVideoModal> allVideos = mapData[1];
        String nextPageToken = mapData[2];
        print('allvideos length ==============> ${allVideos.length}');
        print('token next page  ==============> $nextPageToken');
        emit(YoutubeVideoState(videos: allVideos));
      } catch (error) {
        print('Error $error');
      }
    });

    on<FetchMoreYoutubeVideos>((event, emit) async {
      try {
        print('i am trigger');
        // CustomVideoModal allvideos = await videoRepository.getTheYTVideos(nextPageToken: event.nextPageToken);

        // emit(FetchedPaginatedYTVideos(moreVideos: allvideos));
      } catch (error) {
        print('error occure during fetch more videos $error');
      }
    });
  }
}
