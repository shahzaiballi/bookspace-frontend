import 'package:flutter/material.dart';

import '../../core/constant/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validator.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/glowing_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          size: 48,
                          color: AppColors.accent,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Reset your Novelbook password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // email field
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Enter your registered email',
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 40),

                        // glowing button
                        GlowingButton(
                          text: '',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password reset link sent to your email!',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '  Reset Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '→',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // back to login
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Back to Login ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: '→',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
