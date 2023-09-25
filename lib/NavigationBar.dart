// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/screens/MyAccountPage.dart';
import 'package:panasonic/screens/MyProductsPage.dart';
import 'package:panasonic/screens/SearchPage.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int selectedIndex = 0;
  static List<Widget> pages = <Widget>[];

  void _refresh() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    pages = <Widget>[
      const MyProductsPage(),
      const SearchPage(),
      MyAccountPage(
        refresh: _refresh,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color.fromRGBO(53, 53, 53, 1),
        // backgroundColor: Global.dark ? NavbarColor : const Color.fromRGBO(227, 227, 227, 1),
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'My Products'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Account'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: KPrimayColor,
        onTap: _onItemTapped,
      ),
    );
  }
}



// zeyad@gmail.com

// 06062003


// zeyadali6060@gmail.com

// Ze06062003#


// set@gmail.com

// set.com