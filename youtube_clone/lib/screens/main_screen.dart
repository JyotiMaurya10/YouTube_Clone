import 'package:flutter/material.dart';
import 'package:youtube_clone/features/content/short_video/short_video_page.dart';
import '../features/auth/screens/logout_screen.dart';
import '../features/content/long_video/long_video_screen.dart';
import '../features/search/screen/search_screen.dart';
import '../features/upload/upload_bottom_sheet.dart'; 

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final _screens = [  
    const LongVideoScreen(),
    const ShortVideoPage(), 
    const Scaffold(body: Center(child: Text('Add'))),
    const SearchScreen(), 
    const LogoutPage() 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: _screens[_selectedIndex], 
        body: Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                      i,
                      Offstage(
                        offstage: _selectedIndex != i,
                        child: screen,
                      ),
                    ))
                .values
                .toList()),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          elevation: 10,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            _selectedIndex = index;
            if (_selectedIndex != 2) {
              setState(() {
                _selectedIndex = index;
              });
            } else {
              showModalBottomSheet(
                context: context,
                builder: (context) => const CreateBottomSheet(),
              );
            }
          },
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle_outline),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_rounded),
              activeIcon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        ));
  }
}
