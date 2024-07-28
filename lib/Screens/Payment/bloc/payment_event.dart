part of "../payment.dart";

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class LoadTariffs extends PaymentEvent
{
  const LoadTariffs();

  @override
  List<Object?> get props => [];
}

class BuyTariffEvent extends PaymentEvent {
  final String language;

  @override
  List<Object?> get props => [language];

  const BuyTariffEvent({required this.language});
}

class CancelPurchaseEvent extends PaymentEvent {

  @override
  List<Object?> get props => [];

  const CancelPurchaseEvent();
}

class SuccessPurchaseEvent extends PaymentEvent {

  @override
  List<Object?> get props => [];

  const SuccessPurchaseEvent();
}

class ErrorPurchaseEvent extends PaymentEvent {
  final int error;

  @override
  List<Object?> get props => [error];

  const ErrorPurchaseEvent({required this.error});
}

class SelectTariff extends PaymentEvent {
  final int index;

  const SelectTariff({required this.index});

  @override
  List<Object?> get props => [index];
}

class SetEmailForReceiptEvent extends PaymentEvent {
  final String emailForReceipt;

  @override
  List<Object?> get props => [emailForReceipt];

  const SetEmailForReceiptEvent({required this.emailForReceipt});
}

class SetPaymentMethodEvent extends PaymentEvent {
  final PaymentMethod paymentMethod;

  @override
  List<Object?> get props => [paymentMethod];

  const SetPaymentMethodEvent({required this.paymentMethod});
}