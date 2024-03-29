import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import '../models/custom_video_model.dart';

class VideoRepository {
  final _apiKey = 'AIzaSyBy42hcwYabNiJSz4QoW_cWtDUa1n20eUI';
  Future<Map> getTheYTVideos({String? nextPageToken, String? searchQuery}) async {
    List<CustomVideoModal>? allVideos = [];

    final youtubeApi = YouTubeApi(await clientViaApiKey(_apiKey));

    final searchListResponse = await youtubeApi.search.list(
      ['id,snippet'],
      q: searchQuery,
      type: ['video', 'songs'],
      pageToken: nextPageToken,
      order: 'relevance',
      maxResults: 50,
    );

    final videoIds = searchListResponse.items!.map((item) => item.id!.videoId).toList();

    final videoListResponse = await youtubeApi.videos.list(
      ['id,snippet'],
      id: [videoIds.join(',')],
    );
    List<Video>? videos = videoListResponse.items;
    print(videos?.isEmpty);
    print(videos?.length);
    if (videos != null) {
      for (var vid in videos) {
        CustomVideoModal videos = CustomVideoModal(videoId: vid.id, thumbnail: vid.snippet?.thumbnails?.maxres?.url ?? "", videoTitle: vid.snippet?.title, description: vid.snippet?.description ?? "");
        allVideos.add(videos);
      }
    }
    Map data = {1: allVideos, 2: searchListResponse.nextPageToken};
    return data;
  }
}
