import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../auth/model/user_model.dart';
class ProfileInfo extends StatelessWidget {
  final UserModel user;
  const ProfileInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(user.profilePic),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ), 
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.blueGrey,
              ),
              children: [
                TextSpan(text: "@${user.username}   "),
                TextSpan(
                  text: user.subscriptions.isEmpty
                      ? "No subscriber   "
                      : "${user.subscriptions.length} subscribers   ",
                ),
                TextSpan(
                  text: user.videos == 0 ? "No video" : "${user.videos} videos",
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }
}
