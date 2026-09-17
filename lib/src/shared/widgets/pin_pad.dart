import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';

class PinPad extends StatefulWidget {
  const PinPad({
    required this.onComplete,
    this.onError,
    this.errorMessage,
    super.key,
  });

  final void Function(String pin) onComplete;
  final String? errorMessage;
  final VoidCallback? onError;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  String _digits = '';

  void _push(String digit) {
    if (_digits.length >= 4) return;
    setState(() => _digits += digit);
    if (_digits.length == 4) {
      widget.onComplete(_digits);
      unawaited(Future.microtask(() {
        if (mounted) setState(() => _digits = '');
      }));
    }
  }

  void _pop() {
    if (_digits.isEmpty) return;
    setState(() => _digits = _digits.substring(0, _digits.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Dots(filled: _digits.length),
        if (widget.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorMessage!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 32),
        _Grid(onDigit: _push, onDelete: _pop),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.filled});
  final int filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final active = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.onDigit, required this.onDelete});
  final void Function(String) onDigit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox.shrink();
        if (k == '⌫') {
          return _PinKey(
            label: k,
            onTap: onDelete,
            isSymbol: true,
          );
        }
        return _PinKey(label: k, onTap: () => onDigit(k));
      }).toList(),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({required this.label, required this.onTap, this.isSymbol = false});
  final String label;
  final VoidCallback onTap;
  final bool isSymbol;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isSymbol ? 'Delete' : label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: Text(
            label,
            style: isSymbol
                ? Theme.of(context).textTheme.titleLarge
                : Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
