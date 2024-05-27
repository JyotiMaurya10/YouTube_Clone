import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/account/account_page.dart';
import '../../features/auth/provider/user_provider.dart';
import '../../features/search/screen/search_screen.dart';
import '../error/error.dart';
import '../buttons/imagebutton.dart';
import '../loader/loader.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Image.asset(
            "assets/images/youtube.jpg",
            height: 36,
          ),
          const SizedBox(width: 4),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              height: 42,
              child: ImageButton(
                image: "cast.png",
                onPressed: () {},
                haveColor: false,
              ),
            ),
          ),
          SizedBox(
            height: 38,
            child: ImageButton(
              image: "notification.png",
              onPressed: () {},
              haveColor: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15),
            child: SizedBox(
              height: 41.5,
              child: ImageButton(
                image: "search.png",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                haveColor: false,
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return ref.watch(currentUserProvider).when(
                    data: (currentUser) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountPage(
                                user: currentUser,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.grey,
                          backgroundImage: CachedNetworkImageProvider(
                            currentUser.profilePic,
                          ),
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => const ErrorPage(),
                    loading: () => const Loader(),
                  );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
