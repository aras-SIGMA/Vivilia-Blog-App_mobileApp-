// Dokumentasi:
// File utama aplikasi Flutter.
// Berfungsi sebagai entry point aplikasi,
// memasang Provider, mengatur tema aplikasi,
// dan menentukan konfigurasi awal MaterialApp.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/authProvider.dart';
import 'providers/themeProvider.dart';

import 'screens/mainPage.dart';

void main() {
  runApp(const Restapi());
}

class Restapi extends StatelessWidget {
  const Restapi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..loadUser()),

        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            title: "Blog App",

            themeMode: themeProvider.themeMode,

            theme: ThemeData(brightness: Brightness.light, useMaterial3: true),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),

            routes: {"/main": (context) => const MainPage()},

            home: const MainPage(),
          );
        },
      ),
    );
  }
}
