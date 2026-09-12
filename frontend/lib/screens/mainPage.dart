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

// Halaman wadah utama yang mengatur perpindahan antar fitur aplikasi.
// Tombol aksi mengarahkan user login ke halaman pembuatan artikel.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Menyimpan indeks halaman yang sedang aktif pada navigasi bawah.
  int _bottomNavIndex = 0;

  // Urutan ikon harus sama dengan urutan halaman pada daftar pages.
  final iconList = <IconData>[
    Icons.home_rounded,

    Icons.category_rounded,

    Icons.search_rounded,

    Icons.person_rounded,
  ];

  // Membatasi pembuatan artikel hanya untuk user yang sudah terautentikasi.
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

    // Daftar halaman dibuat saat build agar perubahan state provider tercermin.

    final pages = <Widget>[
      const HomePage(),

      const CategoriesPage(),

      const SearchPage(),

      const UserPage(),
    ];

    // Memastikan halaman utama dibangun ulang ketika status autentikasi berubah.

    context.watch<AuthProvider>();

    return Scaffold(
      body: pages[_bottomNavIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,

        elevation: 8,

        onPressed: openCreateArticle,

        child: const Icon(Icons.add_rounded, size: 32),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,

        activeIndex: _bottomNavIndex,

        leftCornerRadius: 32,

        rightCornerRadius: 32,

        gapLocation: GapLocation.center,

        notchSmoothness: NotchSmoothness.verySmoothEdge,

        backgroundColor: theme.colorScheme.surface,

        activeColor: theme.colorScheme.primary,

        inactiveColor: theme.colorScheme.onSurface.withOpacity(0.5),

        iconSize: 28,

        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
