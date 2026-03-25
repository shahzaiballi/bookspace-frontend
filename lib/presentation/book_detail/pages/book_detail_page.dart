// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/responsive_utils.dart';
import '../controllers/book_detail_controller.dart';
import '../widgets/book_detail_header.dart';
import '../widgets/book_stats_row.dart';
import '../widgets/quick_action_card.dart';
import '../../auth/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class BookDetailPage extends ConsumerWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsyncValue = ref.watch(bookDetailProvider(bookId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.responsive.isLandscape ? 800 : double.infinity),
                child: bookAsyncValue.when(
                   data: (book) => Column(
                     children: [
                       Expanded(
                         child: SingleChildScrollView(
                           padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(16)),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               BookDetailHeader(book: book),
                               SizedBox(height: context.responsive.sp(32)),
                               
                               BookStatsRow(book: book),
                               SizedBox(height: context.responsive.sp(32)),

                               Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(18), fontWeight: FontWeight.bold)),
                               SizedBox(height: context.responsive.sp(16)),

                               QuickActionCard(
                                  title: 'Reading Plan',
                                  subtitle: 'Track your daily progress',
                                  icon: Icons.track_changes,
                                  iconColor: const Color(0xFFB062FF),
                                  onTap: () => context.push('/reading_plan'),
                               ),
                               QuickActionCard(
                                  title: 'Flashcards',
                                  subtitle: 'Review key concepts',
                                  icon: Icons.style,
                                  iconColor: const Color(0xFF4A90E2),
                                  onTap: () => context.push('/flashcards/${book.id}'),
                               ),
                               QuickActionCard(
                                  title: 'Summary',
                                  subtitle: 'Chapter-wise summaries',
                                  icon: Icons.description,
                                  iconColor: const Color(0xFF00B4D8),
                                  onTap: () => context.push('/book_summary/${book.id}'),
                               ),
                               QuickActionCard(
                                  title: 'Discussions',
                                  subtitle: 'Join the conversation',
                                  icon: Icons.chat_bubble_outline,
                                  iconColor: const Color(0xFFE83E8C),
                                  hasNotification: true,
                                  onTap: () => context.push('/all_discussions?bookId=${book.id}'),
                               ),
                             ],
                           ),
                         ),
                       ),
                       
                       // Bottom Pinned Button
                       Container(
                          padding: EdgeInsets.fromLTRB(context.responsive.wp(20), context.responsive.sp(16), context.responsive.wp(20), context.responsive.sp(24)),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10142A),
                            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                          ),
                          child: PrimaryButton(
                            text: 'Continue Reading',
                            onPressed: () => context.push('/chapters/${book.id}'),
                          )
                       )
                     ],
                   ),
                   loading: () => const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)))),
                   error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
                )
              ),
            );
          }
        )
      )
    );
  }
}
