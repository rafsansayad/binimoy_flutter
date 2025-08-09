import 'package:flutter/material.dart';

class ReactionBar extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const ReactionBar({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextStyle countStyle = Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: colorScheme.onSurfaceVariant) ??
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12);

    final Color likeColor = isLiked ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return Row(
      children: [
        _ReactionItem(
          icon: Icons.favorite_rounded,
          color: likeColor,
          count: likeCount,
          onTap: onLike,
          countStyle: countStyle,
        ),
        const SizedBox(width: 12),
        _ReactionItem(
          icon: Icons.mode_comment_rounded,
          color: colorScheme.onSurfaceVariant,
          count: commentCount,
          onTap: onComment,
          countStyle: countStyle,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.ios_share_rounded, color: colorScheme.onSurfaceVariant, size: 20),
          onPressed: onShare,
          tooltip: 'Share',
        ),
      ],
    );
  }
}

class _ReactionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback? onTap;
  final TextStyle countStyle;

  const _ReactionItem({
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
    required this.countStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text('$count', style: countStyle),
          ],
        ),
      ),
    );
  }
}

