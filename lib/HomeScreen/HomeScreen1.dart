import 'package:flutter/material.dart';
import 'package:vuwala/profile/profileScreen.dart';
import '../MapScreen.dart';
import 'HomeScreen.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Column(
          children: [
            Image(
              image: AssetImage('images/home.png'),
              height: 25,
            ),
          ],
        ),
        label: 'Home',
        activeIcon: Column(
          children: [
            Image(
              image: AssetImage('images/home.png'),
              height: 25,
              color: Color(0xff149A9B),
            ),
          ],
        ),
      ),
      BottomNavigationBarItem(
        icon: Column(
          children: [
            Image(
              image: AssetImage('images/map.png'),
              height: 25,
            ),
          ],
        ),
        label: 'Map',
        activeIcon: Column(
          children: [
            Image(
              image: AssetImage('images/map.png'),
              height: 25,
              color: Color(0xff149A9B),
            ),
          ],
        ),
      ),
      BottomNavigationBarItem(
        icon: Column(
          children: [
            Image(
              image: AssetImage('images/profile.png'),
              height: 25,
            ),
          ],
        ),
        label: 'Profile',
        activeIcon: Column(
          children: [
            Image(
              image: AssetImage('images/profile.png'),
              height: 25,
              color: Color(0xff149A9B),
            ),
          ],
        ),
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
  );
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        _onItemTapped(index);
      },
      children: <Widget>[
        HomeScreen(),
        MapScreen(),
        profileScreen(),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  offset: Offset(4, 4),
                  color: Colors.grey[400],
                  blurRadius: 15.0,
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: buildBottomNavBarItems(),
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Color(0xff149A9B),
              selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontFamily: 'regular',
                color: Color(0xff626162),
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontFamily: 'regular',
                color: Color(0xff626162),
              ),
              onTap: _onItemTapped,
            ),
          ),
          body: buildPageView()),
    );
  }
}
