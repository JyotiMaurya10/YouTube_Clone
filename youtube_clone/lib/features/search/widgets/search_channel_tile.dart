import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/buttons/flatbutton.dart';
import '../../auth/model/user_model.dart';
import '../../channel/users_channel/screen/user_channel_page.dart';
import '../../channel/users_channel/subscriber_repository.dart';

class SearchChannelTile extends ConsumerWidget {
  final UserModel user;
  const SearchChannelTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Divider(thickness:1,color: Colors.grey[400],),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserChannelPage(
                  userId: user.userId,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [  
                CircleAvatar(
                    radius: 40, 
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.profilePic),
                  ), 
                const SizedBox(width: 10),
                SizedBox(
                  width: screenWidth / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "@${user.username}",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.subscriptions.isEmpty
                            ? "No subscription"
                            : "${user.subscriptions.length} subscriptions",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        width: 110,
                        child: FlatButton(
                          text: "Subscribe",
                          onPressed: () async {
                            await ref
                                .watch(subscribeChannelProvider)
                                .subscribeChannel(
                                  userId: user.userId,
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  subscriptions: user.subscriptions,
                                );
                          },
                          colour: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ), 
              ],
            ),
          ),
        ), 
      ],
    );
  }
}
