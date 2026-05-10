import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:teamup/router.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/features/home/home.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import '../widgets/widgets.dart';

void _hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Map<String, String> _signupErrors = {};
  String? _selectedUniversity;

  final TextEditingController _fullNameEditController = TextEditingController();
  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();
  final TextEditingController _confirmPasswordEditController =
      TextEditingController();
  final TextEditingController _telegramEditController = TextEditingController();

  @override
  void dispose() {
    _fullNameEditController.dispose();
    _emailEditController.dispose();
    _passwordEditController.dispose();
    _confirmPasswordEditController.dispose();
    _telegramEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.background,
      body: Stack(
        children: [
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
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('🎯', style: TextStyle(fontSize: 40)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join us!!',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create a profile and find a team',
                  style: AppTextStyles.whiteSubtle,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkSurface
                          : AppColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            title: 'Full name',
                            hint: 'Ivan Ivanov',
                            prefixIcon: Icons.person_outline,
                            controller: _fullNameEditController,
                            error: _signupErrors['fullName'],
                          ),
                          CustomTextField(
                            title: 'Email',
                            hint: 'example@university.kz',
                            prefixIcon: Icons.email_outlined,
                            controller: _emailEditController,
                            error: _signupErrors['email'],
                          ),
                          UniversityField(
                            value: _selectedUniversity,
                            error: _signupErrors['university'],
                            onChanged: (value) {
                              setState(() {
                                _selectedUniversity = value;
                              });
                            },
                          ),
                          CustomTextField(
                            title: 'Telegram',
                            hint: '@yourname or your telegram ID',
                            prefixIcon: Icons.send_outlined,
                            controller: _telegramEditController,
                            error: _signupErrors['telegram'],
                          ),
                          CustomTextField(
                            title: 'Password',
                            hint: 'minimum 8 characters',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordEditController,
                            error: _signupErrors['password'],
                          ),
                          CustomTextField(
                            title: 'confirm your password',
                            hint: 'repeat password ',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            controller: _confirmPasswordEditController,
                            error: _signupErrors['confirmPassword'],
                          ),

                          // Firebase error message
                          if (_signupErrors.containsKey("firebase"))
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
                                      _signupErrors["firebase"]!,
                                      style: const TextStyle(
                                        color: AppColors.errorRed,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                          Consumer<MyAuthProvider>(
                            builder: (context, authProvider, child) {
                              return PrimaryButton(
                                text: authProvider.isLoading
                                    ? 'Creating account...'
                                    : 'Create an account',
                                icon: Icons.person_add_alt,
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () => _register(
                                        context,
                                        _fullNameEditController.text,
                                        _emailEditController.text,
                                        _selectedUniversity,
                                        _passwordEditController.text,
                                        _confirmPasswordEditController.text,
                                        _telegramEditController.text,
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 24),
            child: SafeArea(
              child: roundIconBtn(
                icon: Icons.arrow_back,
                onPressed: () => context.go(AppRoutes.login),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _register(
    BuildContext context,
    String fullName,
    String email,
    String? university,
    String password,
    String confirmPassword,
    String telegram,
  ) async {
    // Clear previous errors
    setState(() {
      _signupErrors.remove('firebase');
    });

    // Validate form
    final validationErrors = _checkValidation(
      fullName,
      email,
      university,
      password,
      confirmPassword,
      telegram,
    );

    setState(() {
      _signupErrors = validationErrors;
    });

    if (validationErrors.isNotEmpty) {
      print('[SignupScreen] Validation failed: $validationErrors');
      return;
    }

    print('[SignupScreen] Starting registration...');

    // Firebase sign up with provider
    final authProvider = context.read<MyAuthProvider>();
    final success = await authProvider.signUp(
      email: email,
      password: password,
      fullName: fullName,
      university: university!,
      telegram: telegram,
    );

    if (success && mounted) {
      print('[SignupScreen] Registration successful, navigating to MainScreen');
      context.go(AppRoutes.home);
    } else if (mounted) {
      // Show Firebase error
      final errorMessage = authProvider.error ?? "Sign up failed";
      print('[SignupScreen] Registration failed: $errorMessage');

      // Скрываем клавиатуру
      _hideKeyboard(context);

      // Показываем ошибку в UI
      setState(() {
        _signupErrors["firebase"] = errorMessage;
      });

      // Если email уже в use, показываем также snackbar
      if (errorMessage.contains('already in use')) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            print('[SignupScreen] Showing snackbar for duplicate email');
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'This email is already in use. Please try another email.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                // backgroundColor: isDarkMode
                //     ? AppColors.primaryBlue
                //     : AppColors.primaryPurple,
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        });
      }
    }
  }

  Map<String, String> _checkValidation(
    String fullName,
    String email,
    String? university,
    String password,
    String confirmPassword,
    String telegram,
  ) {
    final Map<String, String> errors = {};

    if (fullName.trim().isEmpty) {
      errors['fullName'] = 'Full name is required';
    } else if (fullName.trim().length < 3) {
      errors['fullName'] = 'Full name is too short';
    }

    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!isEmail(email.trim())) {
      errors['email'] = 'Email is incorrect';
    }

    if (university == null || university.isEmpty) {
      errors['university'] = 'Select your university';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 8) {
      errors['password'] = 'Password is too short (minimum 8 characters)';
    }

    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Confirm password is required';
    } else if (confirmPassword != password) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    if (telegram.trim().isEmpty) {
      errors['telegram'] = 'Telegram is required';
    }

    return errors;
  }

  bool isEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
