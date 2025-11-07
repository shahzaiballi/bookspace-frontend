
import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validator.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/glowing_button.dart';
import '../../shared_widgets/glowing_circle_button.dart';
import '../forgot/forgot_Screen.dart';
import '../home/widgets/glowing_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const GlowingNavBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg',
              fit: BoxFit.cover,
            ),
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
                        const Icon(Icons.menu_book_outlined,
                            size: 48, color: AppColors.accent),
                        const SizedBox(height: 20),
                        const Text(
                          'Welcome back to your novelbook',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // email
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 18),

                        // password
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: _obscure,
                          validator: Validators.validatePassword,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.accent,

                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),


                        GlowingButton(
                          text: '',
                          onTap: () {
                            print('Button Pressed');
                            if (_formKey.currentState!.validate()) {
                              print('Validation Passed');
                              _navigateToHome();
                            } else {
                              print('Validation Failed');
                            }
                          },


                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Continue ',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
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
                        const SizedBox(height: 28),

                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'or continue with',
                                style: TextStyle(color: Colors.white70,fontSize: 16),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GlowingCircleButton(
                              icon: Icons.g_mobiledata,
                              onTap: () {},
                            ),
                            GlowingCircleButton(
                              icon: Icons.mail_outline,
                              onTap: () {},
                            ),
                            GlowingCircleButton(
                              icon: Icons.phone_outlined,
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signup);
                          },

                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'New to Novelbook? Create Account ',
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