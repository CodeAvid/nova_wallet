import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_state.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueueCubit, QueueState>(
      buildWhen: (prev, next) => prev.isOnline != next.isOnline,
      builder: (context, state) {
        return Column(
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: state.isOnline
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _OfflineBanner(context.l10n.offlineBanner),
              secondChild: const SizedBox.shrink(),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFC9962C),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
