import 'package:flutter/material.dart';

class SkeletonFeedItem extends StatelessWidget {
  final bool hasMedia;
  const SkeletonFeedItem({super.key, this.hasMedia = false});

  @override
  Widget build(BuildContext context) {
    final Color base = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6);
    final BorderRadius radius = BorderRadius.circular(12);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _block(size: const Size(40, 40), radius: BorderRadius.circular(20), color: base),
              const SizedBox(width: 12),
              Expanded(child: _block(size: const Size(double.infinity, 12), color: base)),
              const SizedBox(width: 12),
              _block(size: const Size(50, 10), color: base),
            ],
          ),
          const SizedBox(height: 12),
          _block(size: const Size(double.infinity, 12), color: base),
          const SizedBox(height: 8),
          _block(size: const Size(200, 12), color: base),
          if (hasMedia) ...[
            const SizedBox(height: 12),
            ClipRRect(borderRadius: radius, child: _block(size: const Size(double.infinity, 160), color: base)),
          ],
        ],
      ),
    );
  }

  static Widget _block({required Size size, required Color color, BorderRadius? radius}) {
    return Container(
      width: size.width == double.infinity ? double.infinity : size.width,
      height: size.height,
      decoration: BoxDecoration(color: color, borderRadius: radius ?? BorderRadius.circular(6)),
    );
  }
}

