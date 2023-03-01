part of 'video_bloc_bloc.dart';

@immutable
abstract class VideoBlocState {}

class VideoBlocInitial extends VideoBlocState {}

class VideoLoadingState extends VideoBlocState {}

class VideoPlayingLoadingState extends VideoBlocState {}

class FetchedPaginatedYTVideos extends VideoBlocState {
  final CustomVideoModal moreVideos;
  FetchedPaginatedYTVideos({required this.moreVideos});
}

class MiniPlayerLaunchedState extends VideoBlocState {
  final YoutubePlayerController youtubeController;
  final MiniplayerController miniplayerController;
  final CustomVideoModal videoDetail;
  MiniPlayerLaunchedState(
      {required this.youtubeController, required this.miniplayerController, required this.videoDetail});
}

class YoutubeVideoState extends VideoBlocState {
  final List<CustomVideoModal> videos;
  YoutubeVideoState({required this.videos});
}
