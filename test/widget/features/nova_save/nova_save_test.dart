// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/a_savings_goal_with_target_kobo_and_current_kobo.dart';
import './step/the_nova_save_page_is_displayed.dart';
import './step/i_see_text.dart';
import './step/the_device_is_offline.dart';
import './step/a_savings_goal_of_kobo_target_and_kobo_current.dart';
import './step/i_contribute_kobo.dart';
import './step/the_queue_contains_pending_item.dart';

void main() {
  group('''NovaSave Contribution''', () {
    testWidgets(
        '''Outline: Progress percentage is correct at boundaries (100000, 0, '0%')''',
        (tester) async {
      await aSavingsGoalWithTargetKoboAndCurrentKobo(tester, 100000, 0);
      await theNovaSavePageIsDisplayed(tester);
      await iSeeText(tester, '0%');
    });
    testWidgets(
        '''Outline: Progress percentage is correct at boundaries (100000, 50000, '50%')''',
        (tester) async {
      await aSavingsGoalWithTargetKoboAndCurrentKobo(tester, 100000, 50000);
      await theNovaSavePageIsDisplayed(tester);
      await iSeeText(tester, '50%');
    });
    testWidgets(
        '''Outline: Progress percentage is correct at boundaries (100000, 100000, '100%')''',
        (tester) async {
      await aSavingsGoalWithTargetKoboAndCurrentKobo(tester, 100000, 100000);
      await theNovaSavePageIsDisplayed(tester);
      await iSeeText(tester, '100%');
    });
    testWidgets(
        '''Outline: Progress percentage is correct at boundaries (100000, 1000, '1%')''',
        (tester) async {
      await aSavingsGoalWithTargetKoboAndCurrentKobo(tester, 100000, 1000);
      await theNovaSavePageIsDisplayed(tester);
      await iSeeText(tester, '1%');
    });
    testWidgets('''Contribution is queued while offline''', (tester) async {
      await theDeviceIsOffline(tester);
      await aSavingsGoalOfKoboTargetAndKoboCurrent(tester, 100000, 50000);
      await theNovaSavePageIsDisplayed(tester);
      await iContributeKobo(tester, 10000);
      await theQueueContainsPendingItem(tester, 1);
    });
  });
}
