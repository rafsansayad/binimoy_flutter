import 'package:flutter/material.dart';

class MediaPreview extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  final VoidCallback? onTap;
  final double borderRadius;

  const MediaPreview({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.onTap,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              // Reduce memory usage on low-end devices
              cacheWidth: 800,
              cacheHeight: 450,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: cs.surfaceVariant.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: cs.surfaceVariant,
                  alignment: Alignment.center,
                  child: Icon(Icons.image_not_supported_rounded, color: cs.onSurfaceVariant),
                );
              },
            ),
            if (onTap != null)
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
          ],
        ),
      ),
    );
  }
}

