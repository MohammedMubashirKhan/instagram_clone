import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/utils/colors.dart';
import 'package:instragran_clone/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController _pagecontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pagecontroller = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagecontroller.dispose();
  }

  void navigationTap(int page) {
    _pagecontroller.jumpToPage(page);
    // setState(() {
    //   _page = page;
    // });
  }

  void changePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pagecontroller,
        children: homeScreenItems,
        onPageChanged: changePage,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              // color: _page == 0 ? primeColor : secondaryColor,
            ),
            label: "Home",
            backgroundColor: secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: "Search",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: "Person",
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTap,
      ),
    );
  }
}
