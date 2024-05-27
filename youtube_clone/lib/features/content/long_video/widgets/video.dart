import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';
import 'package:youtube_clone/features/upload/long_video/video_repository.dart';
import '../../../../widgets/buttons/flatbutton.dart';
import '../../../../widgets/error/error.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../channel/users_channel/screen/user_channel_page.dart';
import '../../../channel/users_channel/subscriber_repository.dart';
import '../../../upload/comment/comment_model.dart';
import '../../comment/comment_provider.dart';
import '../../comment/comment_sheet.dart';
import 'post.dart';
import 'video_externalbutton.dart';
import 'video_first_comment.dart';

class Video extends ConsumerStatefulWidget {
  final VideoModel video;
  const Video({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  ConsumerState<Video> createState() => _VideoState();
}

class _VideoState extends ConsumerState<Video> {
  bool isShowIcons = false;
  bool isPlaying = true;
  bool islikedvideo = false;
  bool isdislikedvideo = false;
  bool isSubscribed = false;

  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    )..initialize().then((_) {
        _controller!.play();
        setState(() {});
      });
  }

  toggleVideoPlayer() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      isPlaying = false;
      setState(() {});
    } else {
      _controller!.play();
      isPlaying = true;
      setState(() {});
    }
  }

  goBackward() {
    Duration position = _controller!.value.position;
    position = position - const Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  goForward() {
    Duration position = _controller!.value.position;
    position = position + const Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  likeVideo() async {
    await ref.watch(longVideoProvider).likeVideo(
          currentUserId: FirebaseAuth.instance.currentUser!.uid,
          likes: widget.video.likes,
          videoId: widget.video.videoId,
        );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoHeight = screenWidth * 9 / 16;
    final AsyncValue<UserModel> user = ref.watch(
      anyUserDataProvider(widget.video.userId),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(videoHeight - 50),
          child: _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    onTap: isShowIcons
                        ? () {
                            isShowIcons = false;
                            setState(() {});
                          }
                        : () {
                            isShowIcons = true;
                            setState(() {});
                          },
                    child: Stack(
                      children: [
                        VideoPlayer(_controller!),
                        isShowIcons
                            ? Positioned(
                                left: screenWidth / 2 - 25,
                                top: videoHeight / 2 - 25,
                                child: GestureDetector(
                                  onTap: toggleVideoPlayer,
                                  child: SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                      isPlaying
                                          ? "assets/images/pause.png"
                                          : "assets/images/play.png",
                                      color: Colors.white,
                                      height: 50,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        isShowIcons
                            ? Positioned(
                                right: 55,
                                top: videoHeight / 2 - 25,
                                child: GestureDetector(
                                  onTap: goForward,
                                  child: SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                      "assets/images/forward.png",
                                      color: Colors.white,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        isShowIcons
                            ? Positioned(
                                left: 48,
                                top: videoHeight / 2 - 25,
                                child: GestureDetector(
                                  onTap: goBackward,
                                  child: SizedBox(
                                    height: 50,
                                    child: Image.asset(
                                      "assets/images/backward.png",
                                      color: Colors.white,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 7.5,
                            child: VideoProgressIndicator(
                              _controller!,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Loader(),
                ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                widget.video.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Text(
                    widget.video.views == 0
                        ? "No view"
                        : "${widget.video.views} views",
                    style: const TextStyle(
                      fontSize: 13.4,
                      color: Color(0xff5F5F5F),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      timeago.format(widget.video.datePublished),
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserChannelPage(
                      userId: user.value!.userId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                        user.value!.profilePic,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 5,
                      ),
                      child: Text(
                        user.value!.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6, left: 6),
                      child: Text(
                        user.value!.subscriptions.isEmpty
                            ? "00"
                            : "${user.value!.subscriptions.length}",
                        // ? "No subscriber"
                        // : "${user.value!.subscriptions.length} subscribers",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      width: 110,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FlatButton(
                          text: isSubscribed ? "Unsubscribe" : "Subscribe",
                          onPressed: () async {
                            setState(() {
                              isSubscribed = !isSubscribed;
                            });
                            await ref
                                .watch(subscribeChannelProvider)
                                .subscribeChannel(
                                  userId: user.value!.userId,
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  subscriptions: user.value!.subscriptions,
                                );
                          },
                          colour:
                              isSubscribed ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            likeVideo();
                            setState(() {
                              if (islikedvideo == false) {
                                islikedvideo = true;
                                widget.video.likes.length =
                                    widget.video.likes.length + 1;
                              } else {
                                islikedvideo = false;
                                widget.video.likes.length =
                                    widget.video.likes.length - 1;
                              }
                            });
                          },
                          child: Icon(
                            Icons.thumb_up,
                            size: 15.5,
                            color: widget.video.likes.contains(FirebaseAuth
                                        .instance.currentUser!.uid) ||
                                    islikedvideo
                                ? Colors.blue
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text("${widget.video.likes.length}"),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            likeVideo();
                            setState(() {
                              if (isdislikedvideo == false) {
                                isdislikedvideo = true;
                              } else {
                                isdislikedvideo = false;
                              }
                            });
                          },
                          child: Icon(
                            Icons.thumb_down,
                            size: 15.5,
                            color: isdislikedvideo ? Colors.blue : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 9, right: 9),
                    child: VideoExtraButton(
                      text: "Share",
                      iconData: Icons.share,
                    ),
                  ),
                  const VideoExtraButton(
                    text: "Remix",
                    iconData: Icons.analytics_outlined,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 9,
                      right: 9,
                    ),
                    child: VideoExtraButton(
                      text: "Download",
                      iconData: Icons.download,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // comment Box

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => CommentSheet(
                      video: widget.video,
                    ),
                  );
                },
                child: Container(
                  height: 82,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final AsyncValue<List<CommentModel>> comments = ref.watch(
                        commentsProvider(widget.video.videoId),
                      );

                      if (comments.value!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Comments",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      "😃 ",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    Text(" Be the first one to Comment"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return VideoFirstComment(
                        comments: comments.value!,
                        user: user.value!,
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("videos")
                    .where("videoId", isNotEqualTo: widget.video.videoId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const ErrorPage();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Loader();
                  }

                  final videosMap = snapshot.data!.docs;
                  final videos = videosMap
                      .map(
                        (video) => VideoModel.fromMap(video.data()),
                      )
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return Post(
                        video: videos[index],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
