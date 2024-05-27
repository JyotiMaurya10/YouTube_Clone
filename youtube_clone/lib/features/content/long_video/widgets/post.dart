import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_clone/widgets/error/error.dart';
import 'video.dart';

class Post extends ConsumerWidget {
  final VideoModel video;
  const Post({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserModel> userModel =
        ref.watch(anyUserDataProvider(video.userId)); 
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Video(
              video: video,
            ),
          ),
        );

        await FirebaseFirestore.instance
            .collection("videos")
            .doc(video.videoId)
            .update(
          {
            "views": FieldValue.increment(1),
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black54,
                child: CachedNetworkImage(
                  imageUrl: video.thumbnail,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:5,bottom: 10,left: 10 ),
              child: Row( 
                children: [
                  userModel.when(
                    data: (user) => CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                        user.profilePic,
                      ),
                    ),
                    loading: () => const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                    ),
                    error: (_, __) => const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            video.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 3),
                        userModel.when(
                            data: (user) => Flexible(
                                  child: Text(
                                    '${user.displayName} • ${video.views == 0 ? "No View" : "${video.views} views"} • ${timeago.format(video.datePublished)}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            loading: () => const Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            error: (_, __) => const ErrorPage()),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
