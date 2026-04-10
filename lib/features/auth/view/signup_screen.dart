import 'package:flutter/material.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/features/home/home.dart';
import '../widgets/widgets.dart';

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

  @override
  void dispose() {
    _fullNameEditController.dispose();
    _emailEditController.dispose();
    _passwordEditController.dispose();
    _confirmPasswordEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          const SizedBox(height: 16),
                          PrimaryButton(
                            text: 'Create an account',
                            icon: Icons.person_add_alt,
                            onPressed: () => _register(
                              context,
                              _fullNameEditController.text,
                              _emailEditController.text,
                              _selectedUniversity,
                              _passwordEditController.text,
                              _confirmPasswordEditController.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.abc),
            color: Colors.white,
            iconSize: 32,
            padding: const EdgeInsets.only(top: 40),
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
  ) {
    setState(() {
      _signupErrors = _checkValidation(
        fullName,
        email,
        university,
        password,
        confirmPassword,
      );
    });

    if (_signupErrors.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  Map<String, String> _checkValidation(
    String fullName,
    String email,
    String? university,
    String password,
    String confirmPassword,
  ) {
    final Map<String, String> errors = {};

    if (fullName.trim().length < 3) {
      errors['fullName'] = 'full name is too short';
    }
    if (!isEmail(email.trim())) {
      errors['email'] = 'email is incorrect';
    }
    if (university == null || university.isEmpty) {
      errors['university'] = 'select your university';
    }
    if (password.length < 8) {
      errors['password'] = 'password is too short';
    }
    if (confirmPassword != password) {
      errors['confirmPassword'] = 'passwords do not match';
    }

    return errors;
  }

  bool isEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
