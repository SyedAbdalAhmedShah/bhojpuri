import 'package:bojpuri/models/custom_video_model.dart';
import 'package:bojpuri/utils/strings.dart';
import 'package:bojpuri/widgets/custom_gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_app_bar.dart';

class VideoPlayScreen extends StatefulWidget {
  final YoutubePlayerController youtubeController;
  final CustomVideoModal videoDetail;
  final List<CustomVideoModal> recomendationVideo;
  const VideoPlayScreen({required this.youtubeController, required this.videoDetail, required this.recomendationVideo});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  @override
  void dispose() {
    widget.youtubeController.dispose();

    print("dispose called");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(double.infinity, kToolbarHeight + 2.h), child: CustomAppBar()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            bufferIndicator: LinearProgressIndicator(
              color: AppColors.secondaryColor,
            ),
            controller: widget.youtubeController,
            width: double.infinity,
            showVideoProgressIndicator: true,
            progressColors: ProgressBarColors(
                playedColor: AppColors.primaryColor,
                handleColor: AppColors.primaryColor,
                bufferedColor: AppColors.secondaryColor),
          ),
          Text(
            "${widget.videoDetail.videoTitle}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
          ),
          CustomGap(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.recomendation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 8.0,
                          children: List.generate(widget.recomendationVideo.length, (index) {
                            return Card(
                              child: CachedNetworkImage(
                                imageUrl: widget.recomendationVideo[index].thumbnail ?? "",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 26.h,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            );
                          })),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
