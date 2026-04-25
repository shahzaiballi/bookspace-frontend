import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../controllers/summary_controller.dart';
import '../widgets/summary_header_card.dart';
import '../widgets/chapter_summary_accordion.dart';

class ChapterSummaryPage extends ConsumerWidget {
  final String bookId;

  const ChapterSummaryPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Fetch Header Details
    final bookAsync = ref.watch(summaryBookProvider(bookId));
    // 2. Fetch Summaries List
    final summariesAsync = ref.watch(summaryControllerProvider(bookId));

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
          onPressed: () => context.pop(), // Navigates securely back to BookDetailPage
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter Summaries', 
              style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(16), fontWeight: FontWeight.bold)
            ),
            bookAsync.whenOrNull(
              data: (book) => Text(book.title, style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12)))
            ) ?? const SizedBox.shrink(),
          ]
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Card Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(16)),
              child: bookAsync.when(
                data: (book) => SummaryHeaderCard(book: book),
                loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                error: (err, st) => Center(child: Text('Failed to load book', style: TextStyle(color: Colors.redAccent))),
              ),
            ),
          ),
          
          // Accordion List Section
          summariesAsync.when(
            data: (summaries) {
              if (summaries.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(context.responsive.sp(32)),
                      child: Text('No chapter summaries available.', style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(14))),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(20), vertical: context.responsive.sp(8)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ChapterSummaryAccordion(
                      summary: summaries[index],
                      index: index,
                    ),
                    childCount: summaries.length,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator.adaptive())),
            error: (err, st) => SliverToBoxAdapter(child: Center(child: Text('Failed to load summaries', style: TextStyle(color: Colors.redAccent)))),
          ),

          // Safe footer spacing
          SliverToBoxAdapter(child: SizedBox(height: context.responsive.sp(40))),
        ],
      )
    );
  }
}



