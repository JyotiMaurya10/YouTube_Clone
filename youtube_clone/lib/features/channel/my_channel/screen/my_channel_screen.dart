import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import '../../../../widgets/error/error.dart';
import '../../../../widgets/loader/loader.dart';
import '../widgets/buttons.dart';
import '../widgets/tabbar.dart';
import '../widgets/tabbar_view.dart';
import '../widgets/profile_info.dart';

class MyChannelScreen extends ConsumerWidget {
  const MyChannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when(
          data: (currentUser) => DefaultTabController(
            length: 7,
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [ 
                    ProfileInfo(user: currentUser),
                    const Text("More about this channel"),
                    const Buttons(),
                    const PageTabBar(), 
                    const TabPages(),
                  ],
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}
