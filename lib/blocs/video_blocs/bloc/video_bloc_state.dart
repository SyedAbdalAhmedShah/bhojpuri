part of 'video_bloc_bloc.dart';

@immutable
abstract class VideoBlocState {}

class VideoBlocInitial extends VideoBlocState {}

class VideoLoadingState extends VideoBlocState {}

class FetchingMoreVideoLoading extends VideoBlocState {}

class FetchedPaginatedYTVideos extends VideoBlocState {
  final List<CustomVideoModal> moreVideos;
  final String nextPageToken;
  FetchedPaginatedYTVideos({required this.moreVideos, required this.nextPageToken});
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
  final String nextPageToken;
  YoutubeVideoState({required this.videos, required this.nextPageToken});
}

class PlayVideo extends VideoBlocState {
  final PodPlayerController youtubePlayerController;
  PlayVideo({required this.youtubePlayerController});
}
