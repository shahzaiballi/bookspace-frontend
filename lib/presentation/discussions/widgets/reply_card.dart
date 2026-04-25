import 'package:flutter/material.dart';
import '../../../../domain/entities/reply_entity.dart';
import '../../../../core/utils/responsive_utils.dart';

class ReplyCard extends StatelessWidget {
  final ReplyEntity reply;

  const ReplyCard({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(bottom: context.responsive.sp(12)),
       padding: EdgeInsets.all(context.responsive.sp(16)),
       decoration: BoxDecoration(
          color: const Color(0xFF1E233D),
          borderRadius: BorderRadius.circular(context.responsive.sp(12)),
       ),
       child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   CircleAvatar(
                     radius: context.responsive.sp(14),
                     backgroundImage: NetworkImage(reply.userAvatarUrl),
                     backgroundColor: Colors.white12,
                   ),
                   SizedBox(width: context.responsive.wp(12)),
                   Expanded(
                     child: Row(
                        children: [
                          Flexible(
                            child: Text(
                               reply.userName,
                               style: TextStyle(color: Colors.white, fontSize: context.responsive.sp(13), fontWeight: FontWeight.bold),
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: context.responsive.wp(8)),
                            child: Container(width: 3, height: 3, decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle)),
                          ),
                          Text(
                             reply.timeAgo,
                             style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(11)),
                          ),
                        ]
                     )
                   ),
                ],
             ),
             SizedBox(height: context.responsive.sp(12)),

             Text(
               reply.content,
               style: TextStyle(color: Colors.white70, fontSize: context.responsive.sp(13), height: 1.4),
             ),

             SizedBox(height: context.responsive.sp(16)),

             Row(
               children: [
                 Icon(Icons.favorite_border, color: Colors.white54, size: context.responsive.sp(14)),
                 SizedBox(width: context.responsive.wp(6)),
                 Text(reply.likesCount.toString(), style: TextStyle(color: Colors.white54, fontSize: context.responsive.sp(12))),
               ],
             )
          ],
       ),
    );
  }
}

