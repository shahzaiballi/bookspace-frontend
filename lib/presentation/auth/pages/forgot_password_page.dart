import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to OTP with email injected
      context.push('/verify_otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1626), // Dark background matching project
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reset password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  hintText: 'Email address',
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Send Code',
                  onPressed: _handleSendCode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

