import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/services/notification_service.dart';
import '../controllers/flashcard_controller.dart';
import '../widgets/flip_card_widget.dart';
import '../widgets/flashcard_controls.dart';

class FlashcardPage extends ConsumerStatefulWidget {
  final String bookId;

  const FlashcardPage({super.key, required this.bookId});

  @override
  ConsumerState<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends ConsumerState<FlashcardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flashcardIndexProvider(widget.bookId).notifier).reset();
      ref.read(flashcardFlipProvider(widget.bookId).notifier).reset();
    });
  }

  @override
  void dispose() {
    final flashcards = ref.read(flashcardsProvider(widget.bookId)).valueOrNull;
    if (flashcards != null) {
      final currentIndex = ref.read(flashcardIndexProvider(widget.bookId));
      final pendingCount = flashcards.length - currentIndex;
      if (pendingCount > 0) {
        ref.read(notificationServiceProvider).scheduleFlashcardAlert(widget.bookId, pendingCount);
      }
    }
    super.dispose();
  }

  void _handleNextCard(int totalCards) {
    ref.read(flashcardFlipProvider(widget.bookId).notifier).reset();
    ref.read(flashcardIndexProvider(widget.bookId).notifier).nextCard(totalCards);
  }

  Widget _buildCompletionScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, color: Colors.amber, size: context.responsive.sp(80)),
          SizedBox(height: context.responsive.sp(24)),
          Text(
            'Congratulations!',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.responsive.sp(28),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.responsive.sp(8)),
          Text(
            'Deck Completed',
            style: TextStyle(
              color: Colors.white70,
              fontSize: context.responsive.sp(18),
            ),
          ),
          SizedBox(height: context.responsive.sp(48)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB062FF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(32), vertical: context.responsive.sp(16)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.pop(),
            child: Text('Return to Book Details', style: TextStyle(fontSize: context.responsive.sp(16), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcardsAsyncValue = ref.watch(flashcardsProvider(widget.bookId));

    return Scaffold(
      backgroundColor: const Color(0xFF0F1626), // Dark Theme Consistency
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Flashcards',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.sp(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: flashcardsAsyncValue.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return const Center(
              child: Text(
                'No flashcards available.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final currentIndex = ref.watch(flashcardIndexProvider(widget.bookId));
          final isFlipped = ref.watch(flashcardFlipProvider(widget.bookId));

          if (currentIndex >= flashcards.length) {
            return _buildCompletionScreen(context);
          }

          final currentCard = flashcards[currentIndex];
          final progressPercent = (currentIndex + 1) / flashcards.length;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(24), vertical: context.responsive.sp(16)),
              child: Column(
                children: [
                  // Progress Bar Top Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Card ${currentIndex + 1} of ${flashcards.length}',
                        style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(14)),
                      ),
                      Text(
                        '${(progressPercent * 100).toInt()}%',
                        style: TextStyle(
                          color: const Color(0xFFB062FF), 
                          fontSize: context.responsive.sp(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.responsive.sp(8)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.responsive.sp(4)),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)),
                      minHeight: context.responsive.sp(6),
                    ),
                  ),

                  const Spacer(),

                  // The Flashcard itself wrapped in AnimatedSwitcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final inAnimation = Tween<Offset>(
                        begin: const Offset(1.5, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
                      
                      final outAnimation = Tween<Offset>(
                        begin: const Offset(-1.5, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

                      if (child.key == ValueKey(currentCard.id)) {
                        return SlideTransition(position: inAnimation, child: child);
                      } else {
                        return SlideTransition(position: outAnimation, child: child);
                      }
                    },
                    child: FlipCardWidget(
                      key: ValueKey(currentCard.id),
                      flashcard: currentCard,
                      isFlipped: isFlipped,
                      onTap: () {
                        ref.read(flashcardFlipProvider(widget.bookId).notifier).flip();
                      },
                    ),
                  ),

                  const Spacer(),

                  // Controls below card
                  FlashcardControls(
                    isVisible: isFlipped,
                    onReviewLater: () => _handleNextCard(flashcards.length),
                    onGotIt: () => _handleNextCard(flashcards.length),
                  ),

                  SizedBox(height: context.responsive.sp(32)),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB062FF)),
          ),
        ),
        error: (e, st) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
    );
  }
}

