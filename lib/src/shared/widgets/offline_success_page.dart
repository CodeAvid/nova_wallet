import 'package:flutter/material.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';

enum OfflineSuccessType { send, save }

class OfflineSuccessPage extends StatelessWidget {
  const OfflineSuccessPage({
    required this.amountKobo,
    required this.type,
    required this.onBackToHome,
    super.key,
  });

  final int amountKobo;
  final OfflineSuccessType type;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  size: 40,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.offlineSavedTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                formatKobo(amountKobo),
                style: context.currencyDisplay,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.offlineSavedBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onBackToHome,
                child: Text(l10n.backToHome),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
