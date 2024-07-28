part of "../payment.dart";

abstract class PaymentState extends Equatable {
  const PaymentState();
}

enum PaymentMethod {
  applePay,
  card
}

class PaymentInitial extends PaymentState {

  final PageState pageState;
  final List<TariffDetail> tariff;
  final int? selectedTariff;
  final String? paymentRedirectUrl;
  late final PaymentMethod paymentMethod;
  final String emailForReceipt;
  final String? emailForReceiptError;

  // может принимать значения ошибок SKError (https://habr.com/ru/company/adapty/blog/573562/)
  // и http статусов бэкенда (422, 500)
  // TODO: добавить errorDomain для хранения источника ошибок (AppStore, бэкенд) 
  final int? errorCode;

  @override
  List<Object?> get props => [
    pageState,
    tariff,
    selectedTariff,
    paymentRedirectUrl,
    errorCode,
    paymentMethod,
    emailForReceipt,
    emailForReceiptError,
  ];

  PaymentInitial({
    this.pageState = PageState.preload,
    this.tariff = const [],
    this.selectedTariff,
    this.paymentRedirectUrl,
    this.errorCode,
    this.emailForReceipt = "",
    this.emailForReceiptError,
    PaymentMethod? paymentMethod,
  }) {
    if (paymentMethod == null) {
      if (Platform.isIOS) {
        this.paymentMethod = PaymentMethod.applePay;
      } else {
        this.paymentMethod = PaymentMethod.card;
      }
    } else {
      this.paymentMethod = paymentMethod;
    }
  }

  PaymentInitial copyThis({
    PageState? pageState,
    List<TariffDetail>? tariff,
    int? selectedTariff,
    String? paymentRedirectUrl,
    int? errorCode,
    PaymentMethod? paymentMethod,
    String? emailForReceipt,
    Wrapped<String?>? emailForReceiptError,
  }){
    return PaymentInitial(
      pageState: pageState ?? this.pageState,
      tariff: tariff ?? this.tariff,
      selectedTariff: selectedTariff ?? this.selectedTariff,
      paymentRedirectUrl: paymentRedirectUrl ?? this.paymentRedirectUrl,
      errorCode: errorCode ?? this.errorCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      emailForReceipt: emailForReceipt ?? this.emailForReceipt,
      emailForReceiptError: emailForReceiptError != null
          ? emailForReceiptError.value
          : this.emailForReceiptError
    );
  }
}