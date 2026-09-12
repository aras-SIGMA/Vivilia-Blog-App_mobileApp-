import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import 'registerPage.dart';

// Halaman autentikasi yang mengirim kredensial user ke AuthProvider.
// Login yang berhasil mengganti rute saat ini dengan halaman utama aplikasi.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller menyimpan input yang akan diteruskan ke proses login.
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // Mencegah pengiriman berulang dan memberi umpan balik selama proses login.
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    // AuthProvider menangani komunikasi autentikasi dan hasil login.
    final success = await context.read<AuthProvider>().login(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    // User berhasil diarahkan ke halaman utama; kegagalan ditampilkan sebagai pesan.
    if (success) {
      Navigator.pushReplacementNamed(context, "/main");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: Theme.of(context).textTheme.titleLarge),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Email",

                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,

              obscureText: true,

              decoration: const InputDecoration(
                labelText: "Password",

                prefixIcon: Icon(Icons.lock),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : login,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        "Login",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
              ),
            ),

            // Menyediakan jalur navigasi menuju pendaftaran akun baru.
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },

              child: Text(
                "Belum punya akun? Register",

                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
