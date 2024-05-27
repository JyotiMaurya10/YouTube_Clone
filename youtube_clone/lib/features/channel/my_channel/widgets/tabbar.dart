import 'package:flutter/material.dart';

class PageTabBar extends StatelessWidget {
  const PageTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: TabBar(
        tabAlignment: TabAlignment.start, 
        isScrollable: true,
        labelStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.only(top: 12),
        indicatorWeight: 4.0,
        labelPadding: EdgeInsets.only(bottom: 10,right: 16,left: 16,top: 10),
        tabs: [
          Text("Home"),
          Text("Videos"),
          Text("Shorts"),
          Text("Community"),
          Text("Playlists"),
          Text("Channels"),
          Text("About"),
        ],
      ),
    );
  }
}
