import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../widgets/error/error.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../content/long_video/widgets/post.dart';
import '../../users_channel/provider/channel_provider.dart';

class HomeChannelPage extends StatelessWidget {
  const HomeChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return ref
              .watch(eachChannelVideosProvider(
                  FirebaseAuth.instance.currentUser!.uid))
              .when(
                data: (videos) => videos.isEmpty
                    ? const Center(
                        child: Text(
                          "No Video",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 16 / 12.6,  
                          ),
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            if (videos.isNotEmpty) {
                              return Post(video: videos[index]);
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                error: (error, stackTrace) => const ErrorPage(),
                loading: () => const Loader(),
              );
        },
      ),
    );
  }
}
