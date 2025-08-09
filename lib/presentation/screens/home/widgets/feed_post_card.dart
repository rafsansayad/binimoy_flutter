import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';

class FeedPostCard extends StatelessWidget {
  final String userName;
  final String? userAvatarUrl;
  final String actionText; // e.g., 'paid'
  final String counterpartyName;
  final String message;
  final String timeLabel; // e.g., '8m'
  final String? imageUrl;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onTap;

  const FeedPostCard({
    super.key,
    required this.userName,
    required this.userAvatarUrl,
    required this.actionText,
    required this.counterpartyName,
    required this.message,
    required this.timeLabel,
    this.imageUrl,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.onLike,
    this.onComment,
    this.onTap,
  });

  void _openShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final ColorScheme cs = Theme.of(ctx).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.link_rounded, color: cs.primary),
                  title: const Text('Copy link'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: Icon(Icons.share_rounded, color: cs.primary),
                  title: const Text('Share…'),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: Icon(Icons.flag_outlined, color: cs.error),
                  title: const Text('Report'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Avatar(imageUrl: userAvatarUrl, name: userName, size: 44, showBorder: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                          children: [
                            TextSpan(text: userName, style: const TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: ' $actionText '),
                            TextSpan(text: counterpartyName, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(timeLabel, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.more_horiz, color: colorScheme.onSurfaceVariant),
              ],
            ),

            const SizedBox(height: 10),
            // Message (emoji-friendly, slightly larger)
            Text(
              message,
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface, height: 1.3),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            if (imageUrl != null && imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              MediaPreview(imageUrl: imageUrl!),
            ],

            const SizedBox(height: 12),
            // Reactions
            ReactionBar(
              isLiked: isLiked,
              likeCount: likeCount,
              commentCount: commentCount,
              onLike: onLike,
              onComment: onComment,
              onShare: () => _openShare(context),
            ),
          ],
        ),
      ),
    );
  }
}

