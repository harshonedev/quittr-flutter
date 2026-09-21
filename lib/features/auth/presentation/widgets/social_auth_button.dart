import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final String? svgAsset;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.svgAsset,
    this.icon,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor ??
            (isOutlined
                ? theme.colorScheme.surface
                : theme.colorScheme.primary),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isOutlined && backgroundColor == null
                  ? Border.all(color: theme.colorScheme.outline)
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (svgAsset != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SvgPicture.asset(svgAsset!, height: 24),
                  )
                else if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      icon,
                      color: iconColor ??
                          (isOutlined
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onPrimary),
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor ??
                        (isOutlined
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
