import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../controllers/reply_controller.dart';
import '../widgets/post_card.dart';
import '../widgets/reply_card.dart';
import '../widgets/reply_input_bar.dart';

class DiscussionDetailPage extends ConsumerWidget {
  final String postId;

  const DiscussionDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));
    final repliesAsync = ref.watch(replyControllerProvider(postId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      // App bar natively handles safe area top mapping and back arrows seamlessly
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
          // Exiting discussion detail perfectly bounces back to the state managed tab
          onPressed: () => context.pop(), 
        ),
        title: Text('Discussion', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Column(
         children: [
            Expanded(
               child: CustomScrollView(
                  slivers: [
                     // Original Post Header Block
                     SliverToBoxAdapter(
                        child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(16)),
                           child: postAsync.when(
                              data: (post) => PostCard(post: post), // Reusing our exact card component built identically to the feed
                              loading: () => const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)))),
                              error: (err, st) => Center(child: Text('Failed to load post', style: const TextStyle(color: Colors.redAccent))),
                           ),
                        ),
                     ),
                     
                     // Replies Header label
                     SliverToBoxAdapter(
                        child: Padding(
                           padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(8)),
                           child: Text('Replies', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)),
                        ),
                     ),

                     // Replies List
                     repliesAsync.when(
                        data: (replies) {
                           if (replies.isEmpty) {
                              return SliverToBoxAdapter(
                                 child: Center(
                                    child: Padding(
                                       padding: EdgeInsets.all(context.responsive.sp(32)),
                                       child: Text('No replies yet. Be the first to start the conversation!', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14)), textAlign: TextAlign.center),
                                    ),
                                 )
                              );
                           }

                           return SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(12)),
                              sliver: SliverList(
                                 delegate: SliverChildBuilderDelegate(
                                    (context, index) => ReplyCard(reply: replies[index]),
                                    childCount: replies.length,
                                 ),
                              ),
                           );
                        },
                        loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF))))),
                        error: (err, st) => SliverToBoxAdapter(child: Center(child: Text('Failed to load replies', style: const TextStyle(color: Colors.redAccent)))),
                     ),
                  ],
               ),
            ),
            
            // Bottom Action Input docked above keyboards/nav bars
            ReplyInputBar(
               onSend: (text) async {
                  await ref.read(replyControllerProvider(postId).notifier).addReply(text);
               },
            )
         ],
      ),
    );
  }
}

