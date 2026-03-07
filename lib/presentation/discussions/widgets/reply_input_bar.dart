import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class ReplyInputBar extends StatefulWidget {
  final Future<void> Function(String text) onSend;

  const ReplyInputBar({super.key, required this.onSend});

  @override
  State<ReplyInputBar> createState() => _ReplyInputBarState();
}

class _ReplyInputBarState extends State<ReplyInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    await widget.onSend(text);
    if (!mounted) return;
    
    _controller.clear();
    setState(() => _isSending = false);
    
    // Drop keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrapped in SafeArea specifically to address the OS home indicator request
    return Container(
      padding: EdgeInsets.fromLTRB(
         context.responsive.wp(20), 
         context.responsive.sp(12), 
         context.responsive.wp(20), 
         context.responsive.sp(12) + MediaQuery.of(context).padding.bottom // Add precise OS safe drop
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F1626), 
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: context.responsive.sp(48),
              decoration: BoxDecoration(
                color: const Color(0xFF1E233D),
                borderRadius: BorderRadius.circular(context.responsive.sp(24)),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14)),
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          SizedBox(width: context.responsive.wp(12)),
          GestureDetector(
             onTap: _handleSend,
             child: Container(
                width: context.responsive.sp(48),
                height: context.responsive.sp(48),
                decoration: const BoxDecoration(
                   color: Color(0xFFB062FF),
                   shape: BoxShape.circle,
                ),
                child: Center(
                   child: _isSending 
                     ? SizedBox(
                         width: context.responsive.sp(20), 
                         height: context.responsive.sp(20), 
                         child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                       )
                     : Icon(Icons.send, color: Colors.white, size: context.responsive.sp(20)),
                ),
             ),
          )
        ],
      ),
    );
  }
}
