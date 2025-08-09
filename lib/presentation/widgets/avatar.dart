import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;

  const Avatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.onTap,
    this.showBorder = true,
  });

  String _buildInitials(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final List<String> parts = value.trim().split(RegExp(r"\s+"));
    final String first = parts.isNotEmpty ? parts.first.characters.first : '';
    final String last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  Color _backgroundFromName(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final List<Color> palette = <Color>[
      cs.primaryContainer,
      cs.secondaryContainer,
      cs.tertiaryContainer ?? cs.secondaryContainer,
      cs.inversePrimary.withOpacity(0.9),
      cs.surfaceTint.withOpacity(0.3),
    ];
    final int idx = (name?.hashCode ?? 0).abs() % palette.length;
    return palette[idx];
  }

  Color _bestOnColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Border? border = showBorder
        ? Border.all(color: colorScheme.outlineVariant.withOpacity(0.6), width: 1)
        : null;

    final Widget child = (imageUrl != null && imageUrl!.isNotEmpty)
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(size / 2),
              image: DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover),
            ),
          )
        : Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _backgroundFromName(context),
              borderRadius: BorderRadius.circular(size / 2),
              border: border,
            ),
            child: Text(
              _buildInitials(name),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: _bestOnColor(_backgroundFromName(context)),
                fontSize: size * 0.38,
              ),
            ),
          );

    return Semantics(
      label: name ?? 'Avatar',
      child: onTap == null
          ? child
          : InkWell(borderRadius: BorderRadius.circular(size / 2), onTap: onTap, child: child),
    );
  }
}

