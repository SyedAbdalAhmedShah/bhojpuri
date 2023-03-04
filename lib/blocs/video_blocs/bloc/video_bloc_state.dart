part of 'video_bloc_bloc.dart';

@immutable
abstract class VideoBlocState {}

class VideoBlocInitial extends VideoBlocState {}

class VideoLoadingState extends VideoBlocState {}

class FetchedPaginatedYTVideos extends VideoBlocState {
  final CustomVideoModal moreVideos;
  FetchedPaginatedYTVideos({required this.moreVideos});
}

class MiniPlayerLaunchedState extends VideoBlocState {
  final PodPlayerController youtubeController;
  final CustomVideoModal videoDetail;
  MiniPlayerLaunchedState({
    required this.youtubeController,
    required this.videoDetail,
  });
}

class YoutubeVideoState extends VideoBlocState {
  final List<CustomVideoModal> videos;
  YoutubeVideoState({required this.videos});
}

class PlayVideo extends VideoBlocState {
  final PodPlayerController youtubePlayerController;
  PlayVideo({required this.youtubePlayerController});
}
