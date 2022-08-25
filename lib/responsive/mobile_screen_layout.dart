import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/utils/colors.dart';

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
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This is Mobile"),
              Text("This is Home"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This is Mobile"),
              Text("This is Search"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This is Mobile"),
              Text("This is add post"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This is Mobile"),
              Text("This is Favourate"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This is Mobile"),
              Text("This is Person"),
            ],
          ),
        ],
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
              color: _page == 1 ? primeColor : secondaryColor,
            ),
            label: "Search",
            backgroundColor: primeColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primeColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primeColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primeColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primeColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primeColor : secondaryColor,
            ),
            label: "Person",
            backgroundColor: primeColor,
          ),
        ],
        onTap: navigationTap,
      ),
    );
  }
}
