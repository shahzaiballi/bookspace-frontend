import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../domain/entities/add_book_params.dart';
import '../../auth/widgets/custom_text_field.dart';
import '../controllers/add_book_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBookPage extends ConsumerStatefulWidget {
  const AddBookPage({super.key});

  @override
  ConsumerState<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends ConsumerState<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
       final params = AddBookParams(
         title: _titleController.text.trim(),
         author: _authorController.text.trim(),
         isbn: _isbnController.text.trim().isNotEmpty ? _isbnController.text.trim() : null,
       );

       ref.read(addBookControllerProvider.notifier).addBook(params);
    }
  }

  void _handleFileUpload() async {
    // Request permission based on Android Version / Platform
    final status = await Permission.storage.request();
    
    // For Android 13+, photos or media library might be needed instead but storage is a good default check
    if (status.isGranted || await Permission.photos.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'epub'],
      );

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('File selected: ${result.files.single.name}'), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
              content: Text('Storage access is required to upload your books', style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xFF1E152A),
           ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for success or error to close the sheet automatically
    ref.listen<AsyncValue<void>>(addBookControllerProvider, (previous, next) {
       if (!next.isLoading && next.hasValue && previous is AsyncLoading) {
           ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Book added to library!'), backgroundColor: Colors.green),
           );
           context.pop(); // Close bottom sheet
       } else if (next.hasError) {
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
           );
       }
    });

    final isLoading = ref.watch(addBookControllerProvider).isLoading;

    return Container(
      decoration: BoxDecoration(
         color: const Color(0xFF0F1626),
         borderRadius: BorderRadius.vertical(top: Radius.circular(context.responsive.sp(24))),
      ),
      // Padding handles standard padding + safe area bottom + keyboard inset
      padding: EdgeInsets.only(
         bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + context.responsive.sp(24),
         top: context.responsive.sp(24),
         left: context.responsive.wp(24),
         right: context.responsive.wp(24),
      ),
      child: SingleChildScrollView(
         child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               // Drag Handle
               Container(
                 width: context.responsive.wp(40),
                 height: context.responsive.sp(4),
                 margin: EdgeInsets.only(bottom: context.responsive.sp(24)),
                 decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                 ),
               ),

               // Upload Section
               GestureDetector(
                 onTap: _handleFileUpload,
                 child: Container(
                   width: double.infinity,
                   padding: EdgeInsets.all(context.responsive.sp(24)),
                   decoration: BoxDecoration(
                      color: const Color(0xFF1E233D), // Matches existing card colors
                      borderRadius: BorderRadius.circular(context.responsive.sp(16)),
                      border: Border.all(color: Colors.white10),
                   ),
                   child: Column(
                     children: [
                        Container(
                           padding: EdgeInsets.all(context.responsive.sp(16)),
                           decoration: const BoxDecoration(
                              color: Color(0xFF381A5D), // Dark purple circle
                              shape: BoxShape.circle,
                           ),
                           child: Icon(Icons.file_upload_outlined, color: const Color(0xFFB062FF), size: context.responsive.sp(24)),
                        ),
                        SizedBox(height: context.responsive.sp(16)),
                        Text('Upload PDF or EPUB', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
                        SizedBox(height: context.responsive.sp(8)),
                        Text('Tap to browse or drag and drop your file', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)), textAlign: TextAlign.center),
                        SizedBox(height: context.responsive.sp(4)),
                        Text('Supports PDF, EPUB, MOBI up to 50MB', style: TextStyle(color: Colors.white30, fontSize: context.responsive.sp(10)), textAlign: TextAlign.center),
                     ],
                   ),
                 ),
               ),

               SizedBox(height: context.responsive.sp(24)),
               
               // Divider
               Row(
                 children: [
                    const Expanded(child: Divider(color: Colors.white10)),
                    Padding(
                       padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(16)),
                       child: Text('or', style: TextStyle(color: Colors.white30, fontSize: context.responsive.sp(14))),
                    ),
                    const Expanded(child: Divider(color: Colors.white10)),
                 ],
               ),
               
               SizedBox(height: context.responsive.sp(24)),

               // Manual Entry Form
               Container(
                 padding: EdgeInsets.all(context.responsive.sp(20)),
                 decoration: BoxDecoration(
                    color: const Color(0xFF1E233D),
                    borderRadius: BorderRadius.circular(context.responsive.sp(16)),
                    border: Border.all(color: Colors.white10),
                 ),
                 child: Form(
                   key: _formKey,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Icon(Icons.description_outlined, color: const Color(0xFF4A90E2), size: context.responsive.sp(18)),
                           SizedBox(width: context.responsive.wp(8)),
                           Text('Add Manually', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
                         ],
                       ),
                       SizedBox(height: context.responsive.sp(24)),

                       Text('Book Title', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(12))),
                       SizedBox(height: context.responsive.sp(8)),
                       CustomTextField(
                          controller: _titleController,
                          hintText: 'Enter book title',
                          validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                       ),
                       SizedBox(height: context.responsive.sp(16)),

                       Text('Author', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(12))),
                       SizedBox(height: context.responsive.sp(8)),
                       CustomTextField(
                          controller: _authorController,
                          hintText: 'Enter author name',
                          validator: (value) => value == null || value.isEmpty ? 'Author is required' : null,
                       ),
                       SizedBox(height: context.responsive.sp(16)),

                       Text('ISBN (Optional)', style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(12))),
                       SizedBox(height: context.responsive.sp(8)),
                       CustomTextField(
                          controller: _isbnController,
                          hintText: '978-0-...',
                          keyboardType: TextInputType.number,
                       ),
                       SizedBox(height: context.responsive.sp(24)),

                       SizedBox(
                         width: double.infinity,
                         child: OutlinedButton(
                           onPressed: isLoading ? null : _submitForm,
                           style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF282C4A),
                              side: BorderSide.none,
                              padding: EdgeInsets.symmetric(vertical: context.responsive.sp(16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.responsive.sp(8))),
                           ),
                           child: isLoading
                             ? CircularProgressIndicator.adaptive(valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: context.responsive.sp(2))
                             : Text('Add Book', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(14), fontWeight: FontWeight.bold)),
                         ),
                       )
                     ],
                   )
                 ),
               ),
            ],
         ),
      ),
    );
  }
}
