import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/themeProvider.dart';
import '../providers/authProvider.dart';

import 'loginPage.dart';

// Halaman profil pengguna Vivilia
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final themeProvider = context.watch<ThemeProvider>();

    final user = auth.user;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xffF7F7F7)
          : Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Profile",

                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const CircleAvatar(
                radius: 45,

                child: Icon(Icons.person_rounded, size: 50),
              ),

              const SizedBox(height: 15),

              Text(
                user?.name ?? "Guest User",

                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              Text(
                user?.email ?? "guest@example.com",

                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // Theme
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xff181818),

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 10,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),

                  secondary: const Icon(Icons.dark_mode_rounded),

                  title: Text(
                    "Theme",

                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: Text(
                    themeProvider.isDarkMode ? "Dark Mode" : "Light Mode",
                  ),

                  value: themeProvider.isDarkMode,

                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Login / Logout
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xff181818),

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 10,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),

                  leading: Icon(
                    auth.isLoggedIn
                        ? Icons.logout_rounded
                        : Icons.login_rounded,
                  ),

                  title: Text(
                    auth.isLoggedIn ? "Logout" : "Login",

                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,

                    size: 17,

                    color: Colors.grey,
                  ),

                  onTap: () async {
                    if (auth.isLoggedIn) {
                      await auth.logout();
                    } else {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
