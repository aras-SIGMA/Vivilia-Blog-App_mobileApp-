import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import 'loginPage.dart';

// Halaman pendaftaran user baru sebelum user dapat masuk ke aplikasi.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller menampung data identitas dan kredensial dari formulir.
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // Menonaktifkan tombol selama permintaan pendaftaran berlangsung.
  bool isLoading = false;

  Future<void> register() async {
    // Validasi lokal mencegah pengiriman password yang tidak cocok ke server.
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak sama")));

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // AuthProvider meneruskan data pendaftaran ke layanan autentikasi.
      await context.read<AuthProvider>().register(
        name: nameController.text,

        email: emailController.text,

        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register berhasil, silahkan login")),
      );

      // Setelah berhasil, user diarahkan untuk login menggunakan akun baru.
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register", style: Theme.of(context).textTheme.titleLarge),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,

                decoration: const InputDecoration(
                  labelText: "Name",

                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 15),

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

              const SizedBox(height: 15),

              TextField(
                controller: confirmPasswordController,

                obscureText: true,

                decoration: const InputDecoration(
                  labelText: "Confirm Password",

                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: isLoading ? null : register,

                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "Register",

                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                ),
              ),

              // Memungkinkan user yang sudah memiliki akun kembali ke login.
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },

                child: Text(
                  "Sudah punya akun? Login",

                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
