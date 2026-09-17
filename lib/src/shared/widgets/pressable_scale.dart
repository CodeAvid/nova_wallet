import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A minimum 48 dp, accessible press target with restrained tactile feedback.
class PressableScale extends StatelessWidget {
  const PressableScale({
    required this.child,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 140);
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled
              ? () {
                  unawaited(HapticFeedback.selectionClick());
                  onPressed!.call();
                }
              : null,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedScale(
            duration: duration,
            curve: Curves.easeOutCubic,
            scale: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
