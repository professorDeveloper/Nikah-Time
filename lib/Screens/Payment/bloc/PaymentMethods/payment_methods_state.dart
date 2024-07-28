part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();
}

class PaymentMethodsInitial extends PaymentMethodsState {
  @override
  List<Object> get props => [];
}
