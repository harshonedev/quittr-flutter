import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Max width for phone-style layouts when running on wide screens
/// (web / desktop).
const double kMaxContentWidth = 520;

/// Width available to content once capped at [kMaxContentWidth].
double responsiveContentWidth(BuildContext context) =>
    math.min(MediaQuery.sizeOf(context).width, kMaxContentWidth);

/// Centers [child] horizontally and caps its width at [kMaxContentWidth].
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        child: child,
      ),
    );
  }
}

/// Width-capped body that fills at least the viewport height and scrolls
/// when content is taller. Give [child] (typically a [Column] with
/// `mainAxisSize: MainAxisSize.min`) a [MainAxisAlignment] such as
/// `spaceBetween` to distribute leftover height; [Spacer] is not supported.
class ResponsiveScrollBody extends StatelessWidget {
  const ResponsiveScrollBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: kMaxContentWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
