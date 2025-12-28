import 'package:flutter/material.dart';
import 'package:hm_shop/pages/Cart/index.dart';
import 'package:hm_shop/pages/Category/index.dart';
import 'package:hm_shop/pages/Home/index.dart';
import 'package:hm_shop/pages/Mine/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, String>> _tabList = [
    {"title": "首页", "icon": "lib/assets/img.png"},
    {"title": "分类", "icon": "lib/assets/img.png"},
    {"title": "购物车", "icon": "lib/assets/img.png"},
    {"title": "我的", "icon": "lib/assets/img.png"},
  ];
  final List<Widget> _viewList = [
    HomeView(),
    CategoryView(),
    CartView(),
    MineView(),
  ];
  int _currentIndex = 0;
  List<BottomNavigationBarItem> _getTabBarItemList() {
    return List.generate(_tabList.length, (index) {
      return BottomNavigationBarItem(
        icon: Image.asset(_tabList[index]["icon"]!, width: 30, height: 30),
        activeIcon: Image.asset(
          _tabList[index]["icon"]!,
          width: 30,
          height: 30,
        ),
        label: _tabList[index]["title"],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _viewList),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: _getTabBarItemList(),
      ),
    );
  }
}
