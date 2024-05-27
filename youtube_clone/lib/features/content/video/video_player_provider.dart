import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart'; 

class VideoPlayerState {
  final bool isPlaying;
  final bool isShowIcons;

  VideoPlayerState({required this.isPlaying, required this.isShowIcons});

  VideoPlayerState copyWith({bool? isPlaying, bool? isShowIcons}) {
    return VideoPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isShowIcons: isShowIcons ?? this.isShowIcons,
    );
  }
}

class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
  VideoPlayerController? _controller;

  VideoPlayerNotifier()
      : super(VideoPlayerState(isPlaying: false, isShowIcons: false));

  VideoPlayerController? get controller => _controller;

  void initializeController(String videoUrl) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        state = state.copyWith();
      });
  }

  void togglePlayPause() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      _controller!.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  void toggleIconsVisibility() {
    state = state.copyWith(isShowIcons: !state.isShowIcons);
  }

  void seekForward() {
    Duration position =
        _controller!.value.position + const Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  void seekBackward() {
    Duration position =
        _controller!.value.position - const Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  // void likeVideo(
  //     {required String currentUserId,
  //     required List<String> likes,
  //     required String videoId}) {
  //   if (likes.contains(currentUserId)) {
  //     likes.remove(currentUserId);
  //   } else {
  //     likes.add(currentUserId);
  //   }
  //   state = state.copyWith();
  // }

  //  void likeVideo(
  //     {required String currentUserId,
  //     required List<String> likes,
  //     required String videoId}) async {
  //   // Make the method asynchronous
  //   // Get an instance of the longVideoProvider using ref.read
  //   final longVideoProvider = ref.read(longVideoProvider.notifier);
  //   // Call longVideoProvider's likeVideo method asynchronously
  //   await longVideoProvider.likeVideo(
  //     currentUserId: currentUserId,
  //     likes: likes,
  //     videoId: videoId,
  //   );
  //   state = state.copyWith(); // Notify listeners of state change
  // }
  
//  void likeVideo({
//   required ProviderRef ref,
//   required String currentUserId,
//   required List<String> likes,
//   required String videoId,
// }) async {
//   // Access the videoPlayerProvider using ref.read
//   final longVideoProvider = ref.read(videoPlayerProvider.notifier);
//   // Call the likeVideo method of the longVideoProvider
//   await longVideoProvider.likeVideo(
//     currentUserId: currentUserId,
//     likes: likes,
//     videoId: videoId,
//   );
//   state = state.copyWith(); // Notify listeners of state change
// }

//   likeVideo(
//   ref: ref,
//   currentUserId: FirebaseAuth.instance.currentUser!.uid,
//   likes: widget.video.likes,
//   videoId: widget.video.videoId,
// );



  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

final videoPlayerProvider =
    StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>((ref) {
  return VideoPlayerNotifier();
});
