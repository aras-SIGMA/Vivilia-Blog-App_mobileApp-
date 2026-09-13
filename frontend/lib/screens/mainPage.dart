import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';

import 'loginPage.dart';
import 'homePage.dart';
import 'categoriesPage.dart';
import 'searchPage.dart';
import 'userblogPage.dart';
import 'addBlogPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Menyimpan halaman yang sedang aktif
  int _bottomNavIndex = 0;

  // Urutan icon harus sama dengan urutan halaman
  final List<IconData> iconList = [
    Icons.home_rounded,

    Icons.category_rounded,

    Icons.add_rounded,

    Icons.search_rounded,

    Icons.person_rounded,
  ];

  // Membuka halaman tambah artikel
  // Hanya user yang sudah login dapat membuat artikel
  void openCreateArticle() {
    final auth = context.read<AuthProvider>();

    if (auth.isLoggedIn) {
      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (context) => AddBlogPage(
            onArticleCreated: () {
              setState(() {});
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,

        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Memantau perubahan status login
    context.watch<AuthProvider>();

    final pages = <Widget>[
      const HomePage(),

      const CategoriesPage(),

      const SizedBox(),

      const SearchPage(),

      const UserPage(),
    ];

    return Scaffold(
      // Membuat navbar terlihat mengambang
      extendBody: true,

      body: pages[_bottomNavIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, bottom: 22),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),

                blurRadius: 20,

                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),

            child: AnimatedBottomNavigationBar(
              icons: iconList,

              activeIndex: _bottomNavIndex,

              gapLocation: GapLocation.none,

              notchSmoothness: NotchSmoothness.defaultEdge,

              leftCornerRadius: 40,

              rightCornerRadius: 40,

              elevation: 0,

              iconSize: 25,

              backgroundColor: theme.brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF181818),

              activeColor: theme.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,

              inactiveColor: theme.brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white54,

              onTap: (index) {
                // Index 2 adalah tombol tambah artikel

                if (index == 2) {
                  openCreateArticle();

                  return;
                }

                setState(() {
                  _bottomNavIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
