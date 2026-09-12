import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/themeProvider.dart';
import '../providers/authProvider.dart';
import 'loginPage.dart';

// Halaman profil dan preferensi user.
// Menampilkan data akun, mengubah tema, serta menyediakan login atau logout.
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider dipantau agar profil dan kontrol autentikasi selalu mutakhir.
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("User", style: Theme.of(context).textTheme.titleLarge),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Avatar menggunakan ikon default karena aplikasi belum memuat foto profil.
            const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 50)),

            const SizedBox(height: 15),

            Text(
              user?.name ?? "Guest User",

              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 5),

            Text(
              user?.email ?? "guest@example.com",

              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 30),

            // Pengaturan tema dipisahkan sebagai kontrol state yang dapat diubah langsung.
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),

                title: Text(
                  "Settings",

                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),

            const SizedBox(height: 10),

            // Aksi terakhir bergantung pada status autentikasi user saat ini.
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode),

                title: Text(
                  "Theme",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                subtitle: Text(
                  themeProvider.isDarkMode ? "Dark Mode" : "Light Mode",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                value: themeProvider.isDarkMode,

                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),

                title: Text(
                  auth.isLoggedIn ? "Logout" : "Login",

                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                onTap: () async {
                  // User login diarahkan ke form login; user aktif dapat logout langsung.
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
    );
  }
}
