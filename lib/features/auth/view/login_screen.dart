// ==========================================
// 📂 screens/auth/login_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/router.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/features/home/home.dart';
import 'package:teamup/providers/my_auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
  Map<String, String> _loginErrors = {};
  final TextEditingController _emailEditController = TextEditingController(
    text: "a@a.com",
  );
  final TextEditingController _passwordEditController = TextEditingController(
    text: "11111111",
  );

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Logo & Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('🚀', style: TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome back!',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log in to find your team',
                  style: AppTextStyles.whiteSubtle,
                ),
                const SizedBox(height: 32),

                // Form Container (главная часть)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //email field
                          CustomTextField(
                            title: "Email",
                            hint: 'example@university.kz',
                            prefixIcon: Icons.email_outlined,
                            controller: _emailEditController,
                            error: _loginErrors["email"],
                          ),

                          // password field
                          CustomTextField(
                            title: "Password",
                            hint: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordEditController,
                            error: _loginErrors["password"],
                          ),

                          // text button forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot your password?',
                                style: TextStyle(color: AppColors.primaryBlue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Firebase error message
                          if (_loginErrors.containsKey("firebase"))
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.errorRed.withOpacity(0.1),
                                border: Border.all(color: AppColors.errorRed),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: AppColors.errorRed,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _loginErrors["firebase"]!,
                                      style: const TextStyle(
                                        color: AppColors.errorRed,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          //btn login
                          PrimaryButton(
                            text: 'Login',
                            icon: Icons.login,
                            onPressed: () => _login(
                              context,
                              _emailEditController.text,
                              _passwordEditController.text,
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Center(
                            child: Text(
                              'or',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Google Button
                          Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.inputBorder),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'G',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Login with Google',
                                    style: AppTextStyles.subtitle,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: AppTextStyles.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go(AppRoutes.signup);
                                },
                                child: Text(
                                  'Sign up',
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context, String email, String password) async {
    // Basic validation
    Map<String, String> errors = {};
    if (!isEmail(email)) errors["email"] = "Email is incorrect";
    if (password.isEmpty) errors["password"] = "Password cannot be empty";
    if (password.length < 8 && password.isNotEmpty) {
      errors["password"] = "Password is too short";
    }

    setState(() {
      _loginErrors = errors;
    });

    if (errors.isNotEmpty) return;

    // Firebase sign in
    final authProvider = context.read<MyAuthProvider>();
    final success = await authProvider.signIn(email, password);

    if (success && mounted) {
      context.go(AppRoutes.home);
    } else if (mounted) {
      // Show error from provider
      setState(() {
        _loginErrors["firebase"] = authProvider.error ?? "Login failed";
      });
    }
  }

  bool isEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
