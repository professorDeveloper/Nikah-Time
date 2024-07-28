part of "../payment.dart";

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  String? accessToken;
  StreamSubscription? _subscription;
  ProfileBloc profileBloc;

  PaymentBloc({required this.profileBloc}) 
  : super(PaymentInitial()) {
    on<LoadTariffs>(_onLoadTariffs);
    on<SelectTariff>(_onSelectEvent);
    on<BuyTariffEvent>(_onBuyTariffEvent);
    on<CancelPurchaseEvent>(_onCancelPurchaseEvent);
    on<SuccessPurchaseEvent>(_onSuccessPurchaseEvent);
    on<ErrorPurchaseEvent>(_onErrorPurchaseEvent);
    on<SetEmailForReceiptEvent>(_onSetEmailForReceiptEvent);
    on<SetPaymentMethodEvent>(_onSetPaymentMethodEvent);

    if (Platform.isIOS) {
      final Stream purchaseUpdated =
          InAppPurchase.instance.purchaseStream;
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {
          if (purchaseDetailsList.isEmpty) {
            add(const CancelPurchaseEvent());
            return;
          }
          purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
            if (purchaseDetails.status == PurchaseStatus.pending) {

            } else {
              if (purchaseDetails.status == PurchaseStatus.error) {
                int skErrorCode = 0;
                if (purchaseDetails is AppStorePurchaseDetails) {
                  SKPaymentTransactionWrapper skTransaction
                    = purchaseDetails.skPaymentTransaction;
                  skErrorCode = skTransaction.error!.code;

                }
                add(ErrorPurchaseEvent(error: skErrorCode));
              } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                        purchaseDetails.status == PurchaseStatus.restored) {
                try {
                  String receiptData = purchaseDetails.verificationData.localVerificationData;
                  // throw DioError(requestOptions: RequestOptions(path: ""));
                  await NetworkService().verifyPaymentByApplePay(receiptData: receiptData);
                  if (this.isClosed == false) {
                    add(const SuccessPurchaseEvent());
                  }
                } on DioError catch (error) {
                  int errorCode = 0;
                  if (error.response != null) {
                    errorCode = error.response!.statusCode ?? 0;
                  }
                  add(ErrorPurchaseEvent(error: errorCode));
                  return;
                }
              } else if (purchaseDetails.status == PurchaseStatus.canceled) {
                add(const CancelPurchaseEvent());
              }
              if (purchaseDetails.pendingCompletePurchase) {
                await InAppPurchase.instance
                    .completePurchase(purchaseDetails);
              }
            }
          });
        },
        onDone: () {
          _subscription?.cancel();
        },
        onError: (error) {
        debugPrint(error);
      }
    );
    }
  }

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _onLoadTariffs(LoadTariffs event, Emitter emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emailForReceipt = prefs.getString("emailForReceipt");
    emailForReceipt ??= "";
    emit((state as PaymentInitial).copyThis(emailForReceipt: emailForReceipt));

    if (accessToken == null) {
      await getAccessToken();
    }

    var response = await NetworkService().GetTariffs(accessToken: accessToken!);

    if (response.statusCode != 200) {
      emit((state as PaymentInitial).copyThis(pageState: PageState.error));
      return;
    }

    List<TariffDetail> tariffs = [];
    List<dynamic> result = jsonDecode(response.body);
    int userTariff = 0;
    for (int i = 0; i < result[0].length; i++) {
      TariffDetail tariff =
          TariffDetail.fromJson(result[0][i] as Map<String, dynamic>);
      if (tariff.isUserTariff && tariff.id != 1) {
        userTariff = tariff.id;
      }
      if (tariff.id == 1) continue;

      tariffs.add(tariff);
    }

    if (userTariff == 0) {
      userTariff = tariffs.first.id;
    }

    if (Platform.isIOS) {
      Map<String, TariffDetail> tariffsMap = {};
      for (final tariff in tariffs) {
        if (tariff.idOnStore != null) {
          tariffsMap.addEntries({tariff.idOnStore!: tariff}.entries);
        }
      }

      final ProductDetailsResponse storeResponse = await InAppPurchase.instance
          .queryProductDetails(tariffsMap.keys.toSet());
      if (storeResponse.notFoundIDs.isNotEmpty) {
        emit((state as PaymentInitial).copyThis(pageState: PageState.error));
        return;
      }
      List<ProductDetails> detailsOnStoreList = storeResponse.productDetails;
      for (final detailsOnStore in detailsOnStoreList) {
        tariffsMap[detailsOnStore.id] = tariffsMap[detailsOnStore.id]!
            .copyThis(
              price: detailsOnStore.rawPrice,
              currencyCode: detailsOnStore.currencyCode,
              currencySymbol: detailsOnStore.currencySymbol,
              detailsOnStore: Wrapped.value(detailsOnStore)
        );
      }

      tariffs = tariffsMap.values.toList();
    }

    emit((state as PaymentInitial).copyThis(
        pageState: PageState.ready,
        tariff: tariffs,
        selectedTariff: userTariff));
  }

  void _onBuyTariffEvent(BuyTariffEvent event, Emitter emit) async {
    emit((state as PaymentInitial).copyThis(
        emailForReceiptError: const Wrapped<String?>.value(null),
        pageState: PageState.preBuyWaiting
    ));

    final selectedTariffIndex = (state as PaymentInitial).tariff.indexWhere(
            (tariff) => tariff.id == (state as PaymentInitial).selectedTariff
    );
    final selectedTariff = (state as PaymentInitial).tariff[selectedTariffIndex];

    if ((state as PaymentInitial).paymentMethod == PaymentMethod.card) {
      try {
        final String paymentRedirectUrl = await NetworkService().buyTariffByCard(
          tariffId: selectedTariff.id,
          language: event.language,
          emailForReceipt: (state as PaymentInitial).emailForReceipt,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("emailForReceipt", (state as PaymentInitial).emailForReceipt);

        emit((state as PaymentInitial).copyThis(
          pageState: PageState.buyValidation,
          paymentRedirectUrl: paymentRedirectUrl
        ));
      } on NikahError catch (e) {
        switch (e.detail) {
          case "ERR_EMAIL_INVALID":
            emit((state as PaymentInitial).copyThis(
              emailForReceiptError: Wrapped<String?>.value(
                  localize.tr(LocaleKeys.paymentScreen_emailForReceiptError_emailInvalid)
              ),
              pageState: PageState.ready,
            ));
            return;
          case "ERR_EMAIL_REQUIRED":
            emit((state as PaymentInitial).copyThis(
              emailForReceiptError: Wrapped<String?>.value(
                  localize.tr(LocaleKeys.paymentScreen_emailForReceiptError_emailRequired)
              ),
              pageState: PageState.ready,
            ));
            return;
          default:
            emit((state as PaymentInitial).copyThis(pageState: PageState.buyError));
            return;
        }
      } catch (_) {
        emit((state as PaymentInitial).copyThis(pageState: PageState.buyError));
        return;
      }
    } else if ((state as PaymentInitial).paymentMethod == PaymentMethod.applePay && Platform.isIOS) {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: selectedTariff.detailsOnStore!,
        applicationUserName: (profileBloc.state as ProfileInitial)
          .userProfileData!.id!.toString()
      );

      emit((state as PaymentInitial).copyThis(pageState: PageState.buyWaiting));
      try {
        await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
      } on PlatformException catch (e) {
        if (e.code == 'storekit_duplicate_product_object') {
          add(const ErrorPurchaseEvent(error: -1));
        }
      }
    }

  }
  void _onSetEmailForReceiptEvent(SetEmailForReceiptEvent event, Emitter emit) {
    emit((state as PaymentInitial).copyThis(
        emailForReceipt: event.emailForReceipt
    ));
  }

  void _onErrorPurchaseEvent(ErrorPurchaseEvent event, Emitter emit) {
    emit((state as PaymentInitial).copyThis(
      pageState: PageState.buyError,
      errorCode: event.error
    ));
  }

  void _onSuccessPurchaseEvent(SuccessPurchaseEvent event, Emitter emit) {
    emit((state as PaymentInitial).copyThis(pageState: PageState.buySuccess));
  }

  void _onCancelPurchaseEvent(CancelPurchaseEvent event, Emitter emit) {
    emit((state as PaymentInitial).copyThis(pageState: PageState.ready));
  }

  void _onSelectEvent(SelectTariff event, Emitter emit) async {
    emit((state as PaymentInitial).copyThis(pageState: PageState.loading));

    emit((state as PaymentInitial).copyThis(
        pageState: PageState.ready,
        selectedTariff: event.index
    ));
  }

  void _onSetPaymentMethodEvent(SetPaymentMethodEvent event, Emitter emit) async {
    emit((state as PaymentInitial).copyThis(paymentMethod: event.paymentMethod));
  }
}
