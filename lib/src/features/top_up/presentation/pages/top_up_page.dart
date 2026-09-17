import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nova_wallet/l10n/l10n.dart';
import 'package:nova_wallet/src/core/utils/kobo_formatter.dart';
import 'package:nova_wallet/src/features/top_up/presentation/cubit/top_up_cubit.dart';
import 'package:nova_wallet/src/features/top_up/presentation/cubit/top_up_state.dart';
import 'package:nova_wallet/src/shared/theme/app_theme.dart';
import 'package:nova_wallet/src/shared/widgets/offline_success_page.dart';

final _nairaFmt = NumberFormat('#,##0.00');

class TopUpPage extends StatefulWidget {
  const TopUpPage({required this.onExit, super.key});

  final VoidCallback onExit;

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopUpCubit, TopUpState>(
      builder: (context, state) {
        if (state is TopUpQueued) {
          return state.isOffline
              ? OfflineSuccessPage(
                  amountKobo: state.amountKobo,
                  type: OfflineSuccessType.send,
                  onBackToHome: widget.onExit,
                )
              : _TopUpSuccessPage(
                  amountKobo: state.amountKobo,
                  onDone: widget.onExit,
                );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.topUpTitle),
            leading: BackButton(onPressed: widget.onExit),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[\d,.]'),
                          ),
                          LengthLimitingTextInputFormatter(14),
                        ],
                        onChanged: (_) => setState(() => _error = null),
                        decoration: InputDecoration(
                          labelText: context.l10n.amountFieldLabel,
                          errorText: _error,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [100000, 500000, 1000000, 5000000].map((kobo) {
                          return ActionChip(
                            label: Text(formatKobo(kobo)),
                            onPressed: () {
                              _controller.text = _nairaFmt.format(kobo / 100);
                              setState(() => _error = null);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      final naira = double.tryParse(
                        _controller.text.replaceAll(',', ''),
                      );
                      final kobo =
                          naira != null ? (naira * 100).round() : null;
                      if (kobo == null || kobo <= 0) {
                        setState(
                          () => _error = context.l10n.invalidTopUpAmount,
                        );
                        return;
                      }
                      setState(() => _error = null);
                      unawaited(context.read<TopUpCubit>().submit(kobo));
                    },
                    child: Text(context.l10n.topUpButton),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopUpSuccessPage extends StatelessWidget {
  const _TopUpSuccessPage({required this.amountKobo, required this.onDone});

  final int amountKobo;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Scaffold(
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
              decoration: const BoxDecoration(
                color: AppColors.successContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.topUpSuccessTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              formatKobo(amountKobo),
              style: context.currencyDisplay,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onDone,
              child: Text(context.l10n.backToHome),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}
