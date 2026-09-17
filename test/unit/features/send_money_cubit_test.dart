import 'package:flutter_test/flutter_test.dart';
import 'package:nova_wallet/src/core/queue/data/repositories/in_memory_queue_repository.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/queue_status.dart';
import 'package:nova_wallet/src/core/queue/domain/usecases/enqueue_transaction_usecase.dart';
import 'package:nova_wallet/src/features/send_money/domain/usecases/send_money_usecase.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_cubit.dart';
import 'package:nova_wallet/src/features/send_money/presentation/cubit/send_money_state.dart';

void main() {
  test('rejects malformed recipients and non-positive amounts', () {
    final cubit = SendMoneyCubit(
      SendMoneyUseCase(EnqueueTransactionUseCase(InMemoryQueueRepository())),
    );

    void expectError() => expect(cubit.state, isA<SendMoneyError>());

    cubit.setRecipient('!');
    expectError();
    cubit
      ..setRecipient('ACC-001')
      ..setAmount(0);
    expectError();
  });

  test(
    'ignores a second confirm while the first request is in flight',
    () async {
      final repository = InMemoryQueueRepository();
      final cubit =
          SendMoneyCubit(
              SendMoneyUseCase(EnqueueTransactionUseCase(repository)),
            )
            ..setRecipient('ACC-001')
            ..setAmount(10000);

      final first = cubit.confirm();
      final second = cubit.confirm();
      await Future.wait(<Future<void>>[first, second]);

      expect(await repository.getByStatus(QueueStatus.pending), hasLength(1));
    },
  );
}
