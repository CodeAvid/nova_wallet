import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova_wallet/src/core/queue/domain/entities/transaction_type.dart';
import 'package:nova_wallet/src/core/queue/presentation/cubit/queue_cubit.dart';
import 'package:nova_wallet/src/features/top_up/presentation/cubit/top_up_state.dart';
import 'package:uuid/uuid.dart';

class TopUpCubit extends Cubit<TopUpState> {
  TopUpCubit(this._queueCubit) : super(const TopUpInitial());

  final QueueCubit _queueCubit;

  Future<void> submit(int amountKobo) async {
    await _queueCubit.enqueue(
      idempotencyKey: const Uuid().v4(),
      type: TransactionType.topUp,
      amountKobo: amountKobo,
      targetId: 'top_up',
    );
    emit(TopUpQueued(
      amountKobo: amountKobo,
      isOffline: !_queueCubit.state.isOnline,
    ));
  }
}
