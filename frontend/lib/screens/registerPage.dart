import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';

import 'loginPage.dart';

// Halaman registrasi pengguna Vivilia
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
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
      await context.read<AuthProvider>().register(
        name: nameController.text,

        email: emailController.text,

        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register berhasil, silahkan login")),
      );

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

  Widget inputField({
    required TextEditingController controller,

    required String hint,

    required IconData icon,

    bool obscure = false,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? Colors.white
            : const Color(0xff181818),

        borderRadius: BorderRadius.circular(18),
      ),

      child: TextField(
        controller: controller,

        obscureText: obscure,

        decoration: InputDecoration(
          hintText: hint,

          prefixIcon: Icon(icon),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? const Color(0xffF7F7F7)
          : Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const SizedBox(height: 50),

                Text(
                  "Vivilia",

                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 45),

                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "Create Account ✨",

                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "Join Vivilia and start sharing your articles",

                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 35),

                inputField(
                  controller: nameController,

                  hint: "Name",

                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 15),

                inputField(
                  controller: emailController,

                  hint: "Email",

                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 15),

                inputField(
                  controller: passwordController,

                  hint: "Password",

                  icon: Icons.lock_outline,

                  obscure: true,
                ),

                const SizedBox(height: 15),

                inputField(
                  controller: confirmPasswordController,

                  hint: "Confirm Password",

                  icon: Icons.lock_reset,

                  obscure: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  height: 52,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,

                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            height: 22,

                            width: 22,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Register"),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },

                  child: const Text("Sudah punya akun? Login"),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
