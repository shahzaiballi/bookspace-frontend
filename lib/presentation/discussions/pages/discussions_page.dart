// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../controllers/discussion_controller.dart';
import '../widgets/post_card.dart';

class DiscussionsPage extends ConsumerWidget {
  final String? bookId;
  const DiscussionsPage({super.key, this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(discussionFilterProvider);
    final postsAsync = ref.watch(discussionControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
               padding: EdgeInsets.fromLTRB(context.responsive.wp(24), context.responsive.sp(20), context.responsive.wp(24), context.responsive.sp(8)),
               child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Discussions', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(24), fontWeight: FontWeight.bold)),
                    SizedBox(height: context.responsive.sp(6)),
                    Text('Join the conversation with readers', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12))),
                  ],
               ),
            ),
            
            SizedBox(height: context.responsive.sp(16)),

            // Filter Tabs (Segmented Navigation)
            SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20)),
               child: Row(
                  children: ['All', 'Popular', 'Recent', 'My Posts'].map((filter) {
                     final isSelected = activeFilter == filter;
                     return GestureDetector(
                        onTap: () => ref.read(discussionFilterProvider.notifier).state = filter,
                        child: Container(
                           margin: EdgeInsets.only(right: context.responsive.wp(12)),
                           padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(16), vertical: context.responsive.sp(8)),
                           decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFB062FF) : const Color(0xFF1E233D),
                              borderRadius: BorderRadius.circular(context.responsive.sp(20)),
                           ),
                           child: Text(
                              filter,
                              style: TextStyle(
                                 color: isSelected ? Colors.white : Colors.white70, 
                                 fontSize: context.responsive.sp(13),
                                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                              ),
                           ),
                        ),
                     );
                  }).toList(),
               ),
            ),

            SizedBox(height: context.responsive.sp(20)),

            // Dynamic Post Feed
            Expanded(
               child: postsAsync.when(
                   data: (posts) {
                      final filteredPosts = bookId != null 
                          ? posts.where((p) => p.bookId == bookId).toList() 
                          : posts;
                          
                      if (filteredPosts.isEmpty) {
                         return Center(child: Text('No posts found.', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14))));
                      }
                      return ListView.builder(
                         padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(8)),
                         itemCount: filteredPosts.length,
                         itemBuilder: (context, index) {
                            return PostCard(post: filteredPosts[index]);
                         },
                      );
                   },
                  loading: () => const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)))),
                  error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
               ),
            )
          ],
        )
      ),
      // Floating Action Button
      floatingActionButton: Container(
         decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
               colors: [Color(0xFF9146FF), Color(0xFF3861FB)],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
            ),
            boxShadow: [
               BoxShadow(color: const Color(0xFFB062FF).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
            ]
         ),
         child: FloatingActionButton(
            onPressed: () => context.push('/new_discussion'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(Icons.add, color: Colors.white, size: context.responsive.sp(28)),
         ),
      ),
    );
  }
}

