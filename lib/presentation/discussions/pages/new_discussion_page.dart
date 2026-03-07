import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../auth/widgets/custom_text_field.dart';

class NewDiscussionPage extends StatefulWidget {
  const NewDiscussionPage({super.key});

  @override
  State<NewDiscussionPage> createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {
  final TextEditingController _bookController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _thoughtsController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _bookController.dispose();
    _chapterController.dispose();
    _titleController.dispose();
    _thoughtsController.dispose();
    super.dispose();
  }

  void _submitDiscussion() async {
    if (_titleController.text.trim().isEmpty || _thoughtsController.text.trim().isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide a title and your thoughts.')));
       return;
    }

    setState(() => _isSubmitting = true);
    
    // Simulate network delay for creating a post
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    setState(() => _isSubmitting = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Discussion posted successfully!'), backgroundColor: Colors.green),
    );
    
    // Drop back to main feed
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1626),
        elevation: 0,
        leading: IconButton(
          icon: Container(
             padding: EdgeInsets.all(context.responsive.sp(8)),
             decoration: const BoxDecoration(
                color: Color(0xFF1E233D),
                shape: BoxShape.circle,
             ),
             child: Icon(Icons.arrow_back, color: Colors.white, size: context.responsive.sp(18)),
          ),
          onPressed: () => context.pop(), 
        ),
        title: Text('New Discussion', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SafeArea(
         child: SingleChildScrollView(
            padding: EdgeInsets.all(context.responsive.wp(24)),
            child: Container(
               padding: EdgeInsets.all(context.responsive.wp(20)),
               decoration: BoxDecoration(
                  color: const Color(0xFF1E233D),
                  borderRadius: BorderRadius.circular(context.responsive.sp(16)),
               ),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     _buildLabel('Book'),
                     CustomTextField(
                        controller: _bookController,
                        hintText: 'e.g., Atomic Habits',
                     ),
                     SizedBox(height: context.responsive.sp(16)),
                     
                     _buildLabel('Chapter'),
                     CustomTextField(
                        controller: _chapterController,
                        hintText: 'e.g., Chapter 3', label: '',
                     ),
                     SizedBox(height: context.responsive.sp(16)),
                     
                     _buildLabel('Discussion Title'),
                     CustomTextField(
                        controller: _titleController,
                        hintText: 'What do you want to discuss?',
                     ),
                     SizedBox(height: context.responsive.sp(16)),

                     _buildLabel('Your Thoughts'),
                     Container(
                        decoration: BoxDecoration(
                           color: const Color(0xFF0F1626),
                           borderRadius: BorderRadius.circular(context.responsive.sp(12)),
                           border: Border.all(color: Colors.white12),
                        ),
                        child: TextField(
                           controller: _thoughtsController,
                           maxLines: 6,
                           style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14)),
                           decoration: InputDecoration(
                              hintText: 'Share your insights, questions, or ideas...',
                              hintStyle: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(context.responsive.sp(16)),
                           ),
                        ),
                     ),
                     
                     SizedBox(height: context.responsive.sp(24)),

                     SizedBox(
                        width: double.infinity,
                        height: context.responsive.sp(50),
                        child: DecoratedBox(
                           decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                 colors: [Color(0xFF9146FF), Color(0xFF3861FB)],
                              ),
                              borderRadius: BorderRadius.circular(context.responsive.sp(12)),
                           ),
                           child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _submitDiscussion,
                              icon: _isSubmitting 
                                 ? SizedBox(width: context.responsive.sp(20), height: context.responsive.sp(20), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                 : Icon(Icons.send, color: Colors.white, size: context.responsive.sp(18)),
                              label: Text(
                                 _isSubmitting ? 'Posting...' : 'Start Discussion',
                                 style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(15), fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.transparent,
                                 shadowColor: Colors.transparent,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.responsive.sp(12))),
                              ),
                           ),
                        ),
                     )
                  ],
               ),
            ),
         ),
      ),
    );
  }

  Widget _buildLabel(String text) {
     return Padding(
        padding: EdgeInsets.only(bottom: context.responsive.sp(8)),
        child: Text(
           text,
           style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(13)),
        ),
     );
  }
}
