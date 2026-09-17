import 'package:equatable/equatable.dart';

sealed class TopUpState extends Equatable {
  const TopUpState();
}

final class TopUpInitial extends TopUpState {
  const TopUpInitial();
  @override
  List<Object?> get props => [];
}

final class TopUpQueued extends TopUpState {
  const TopUpQueued({required this.amountKobo, required this.isOffline});
  final int amountKobo;
  final bool isOffline;
  @override
  List<Object?> get props => [amountKobo, isOffline];
}
