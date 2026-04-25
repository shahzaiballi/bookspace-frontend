import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../widgets/primary_button.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  int _secondsRemaining = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120; // 2 minutes
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _handleVerify() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 4) {
       // Code looks filled, navigate back to login indicating success (or directly home)
       context.go('/login');
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset successfully.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter all 4 digits')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1626), 
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter the 4-digit code sent to your email address.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildPinBox(index)),
              ),
              
              const SizedBox(height: 48),
              PrimaryButton(
                text: 'Verify',
                onPressed: _handleVerify,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend code in ',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  Text(
                    '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Color(0xFFB062FF), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              if (_secondsRemaining == 0) ...[
                 const SizedBox(height: 8),
                 Center(
                    child: TextButton(
                      onPressed: () {
                         _startTimer();
                      },
                      child: const Text('Resend Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                 )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinBox(int index) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F36),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _focusNodes[index].hasFocus ? const Color(0xFFB062FF) : Colors.white12),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          inputFormatters: [
             LengthLimitingTextInputFormatter(1),
             FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 3) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            } else if (value.isEmpty && index > 0) {
               _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}

