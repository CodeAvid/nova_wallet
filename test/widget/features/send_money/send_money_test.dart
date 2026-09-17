// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_device_is_offline.dart';
import './step/the_wallet_balance_is_kobo.dart';
import './step/the_send_money_page_is_displayed.dart';
import './step/i_enter_as_recipient.dart';
import './step/i_tap_the_next_button.dart';
import './step/i_enter_kobo_amount.dart';
import './step/i_tap_the_send_button.dart';
import './step/the_queue_contains_pending_item.dart';
import './step/the_send_money_page_is_rebuilt.dart';
import './step/the_queue_still_contains_pending_item.dart';
import './step/the_idempotency_key_has_not_changed.dart';

void main() {
  group('''Send Money''', () {
    testWidgets('''Queues a transfer while offline''', (tester) async {
      await theDeviceIsOffline(tester);
      await theWalletBalanceIsKobo(tester, 500000);
      await theSendMoneyPageIsDisplayed(tester);
      await iEnterAsRecipient(tester, 'ACC-001');
      await iTapTheNextButton(tester);
      await iEnterKoboAmount(tester, 10000);
      await iTapTheNextButton(tester);
      await iTapTheSendButton(tester);
      await theQueueContainsPendingItem(tester, 1);
    });
    testWidgets('''Idempotency key is not regenerated on rebuild''',
        (tester) async {
      await theWalletBalanceIsKobo(tester, 500000);
      await theSendMoneyPageIsDisplayed(tester);
      await iEnterAsRecipient(tester, 'ACC-001');
      await iTapTheNextButton(tester);
      await iEnterKoboAmount(tester, 10000);
      await iTapTheNextButton(tester);
      await iTapTheSendButton(tester);
      await theQueueContainsPendingItem(tester, 1);
      await theSendMoneyPageIsRebuilt(tester);
      await theQueueStillContainsPendingItem(tester, 1);
      await theIdempotencyKeyHasNotChanged(tester);
    });
  });
}
