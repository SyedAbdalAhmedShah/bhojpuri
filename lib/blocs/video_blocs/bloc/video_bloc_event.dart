part of 'video_bloc_bloc.dart';

@immutable
abstract class VideoBlocEvent {}

class PlayVideoEvent extends VideoBlocEvent {
  final CustomVideoModal video;
  PlayVideoEvent({required this.video});
}

class FetchMoreYoutubeVideos extends VideoBlocEvent {
  final String nextPageToken;
  FetchMoreYoutubeVideos({required this.nextPageToken});
}

class GetYoutubeVideos extends VideoBlocEvent {}

class SearchYtSongs extends VideoBlocEvent {
  final String query;
  SearchYtSongs({required this.query});
}

class LoadVideo extends VideoBlocEvent {
  final CustomVideoModal videoModal;
  LoadVideo({required this.videoModal});
}
