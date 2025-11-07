
import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validator.dart';
import '../../shared_widgets/custom_textfield.dart';
import '../../shared_widgets/glowing_button.dart';
import '../../shared_widgets/glowing_circle_button.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Helper method to build the content Column
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined,
                size: 48, color: AppColors.accent),
            const SizedBox(height: 20),
            const Text(
              'Create your Novelbook account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 36),

            // Name
            CustomTextField(
              controller: _nameController,
              hintText: 'Full Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // Email
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 18),

            // Password
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
            const SizedBox(height: 22),

            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: _obscure,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return Validators.validatePassword(value);
              },
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
            const SizedBox(height: 22),

            // Continue Button
            GlowingButton(
              text: '',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account created successfully!'),
                    ),
                  );
                }
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '   Sign Up ',
                      style: TextStyle(
                          fontSize: 18, color: Colors.white),
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

            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.white24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    'or sign up with',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                ),
                Expanded(child: Divider(color: Colors.white24)),
              ],
            ),
            const SizedBox(height: 20),

            // Social Buttons
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
            const SizedBox(height: 10),
            // Go to Login
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Already have an account? Login',
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

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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

          LayoutBuilder(
            builder: (context, constraints) {

              return SingleChildScrollView(

                child: ConstrainedBox(
                  constraints: BoxConstraints(

                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: _buildContent(context),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}