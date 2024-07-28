part of "../payment.dart";

class PaymentView extends StatefulWidget {
  const PaymentView();

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  TextEditingController _emailForReceiptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider.value(
        //   value: context.read<ProfileBloc>()
        // ),
        BlocProvider(
          create: (context) => PaymentBloc(profileBloc: context.read<ProfileBloc>())
        )
      ],
      child: BlocBuilder<PaymentBloc, PaymentState>(
        buildWhen: (previous, current) {
          if ((previous as PaymentInitial).emailForReceipt != (current as PaymentInitial).emailForReceipt) {
            return false;
          }

          return true;
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                /*appBar: const CustomAppBar(),*/
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_sharp,
                          color: const Color.fromARGB(255, 33, 33, 33),
                          size: 14,
                        ),
                        SizedBox(width: 16,),
                        buildHeader(context)
                      ],
                    ),
                  ),
                  automaticallyImplyLeading: false,
                ),
                body: buildBody(context, state as PaymentInitial),
              ),
              Visibility(
                visible: state.pageState == PageState.buyWaiting,
                child: buildBPaymentWaitingModalBarrier()
              ),
            ],
          );
        }
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Text(
      LocaleKeys.paymentScreen_tittle.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: const Color.fromARGB(255, 33, 33, 33),
      ),
    );
  }

  Widget buildBPaymentWaitingModalBarrier() {
    return Stack(
      children: const [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(
              dismissible: false,
              color: Colors.black
          ),
        ),
        Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context, PaymentInitial state) {
    Widget content;
    switch(state.pageState) {
      case PageState.preload:
        context.read<PaymentBloc>().add(const LoadTariffs());
        content = const SizedBox(
            height: 128,
            child: Center(
                child: CircularProgressIndicator()
            )
        );
        break;
      case PageState.buySuccess:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ProfileBloc>().add(const LoadProfileDataEvent());
          Navigator.of(context).pop();
        });
        content = buildContent(context, state);
        break;
      case PageState.buyError:
      WidgetsBinding.instance.addPostFrameCallback((_) {
          showErrorPaymentDialog(context, state);
        });
        content = buildContent(context, state);
        break;
      case PageState.preBuyWaiting:
      case PageState.buyWaiting:
      case PageState.buyValidation:
      case PageState.ready:
        content = buildContent(context, state);
        break;
      default:
        content = Center(
          child: Text(
            LocaleKeys.entering_recoveryBy_error.tr(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
            ),
          ),
        );
    }

    return Stack(
      children: [
        AppBackgroundImage.instance.buildFadeInBackgroundImage(),
        // SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   child: AppBackgroundImage.instance.buildFadeInBackgroundImage()
        // ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content
            ]
          ),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context, PaymentInitial state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    border: Border.all(
                        color: const Color.fromRGBO( 0, 207, 145, 0.5),
                        width: 2
                    )
                ),
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    tariffsTable(context, state),
                    const SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: buildButton(context, state),
                      ),
                    ),
                  ],
                )
            ),

          ]
      ),
    );
  }

  Widget buildPaymentButton(
      BuildContext context,
      PaymentInitial state, {
      void Function()? pressedHandler,
  }) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12.0),
      ),
      color: const Color.fromARGB(255, 0, 207, 145),
      onPressed: () async {
        if (state.pageState == PageState.preBuyWaiting) {
          return;
        }
        context.read<PaymentBloc>().add(
            BuyTariffEvent(language: context.locale.languageCode)
        );
        if (pressedHandler != null) {
          pressedHandler();
        }
      },
      child: state.pageState == PageState.preBuyWaiting
        ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
      : Text(
        LocaleKeys.paymentScreen_continue.tr(),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white),
      ),
    );
  }

  Widget buildButton(BuildContext context, PaymentInitial state) {
    Widget widget;

    Widget button = MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(12.0),
        ),
        color: const Color.fromARGB(255, 0, 207, 145),
        onPressed: () async {
          // context.read<PaymentBloc>().add(
          //     BuyTariffEvent(language: context.locale.languageCode)
          // );
          showPaymentMethodsDialog(context, state);
        },
        child: Text(
          LocaleKeys.paymentScreen_paymentButton.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.white),
        ),
      );

    Widget text = Center(
        child: Text(
          LocaleKeys.paymentScreen_paymentDone.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color.fromARGB(255, 0, 207, 145),
          ),
        ),
      );

    final selectedTariffIndex = (state).tariff.indexWhere(
            (tariff) => tariff.id == (state).selectedTariff
    );

    if (selectedTariffIndex == -1 || selectedTariffIndex >= (state).tariff.length) {
      return button;
    }

    final selectedTariff = (state).tariff[selectedTariffIndex];

    if (state.selectedTariff != null 
      && selectedTariff.isUserTariff) {
      widget = text;
    } else {
      widget = button;
    }

    return widget;
  }


  Widget tariffsTable(BuildContext context, PaymentInitial state)
  {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        state as PaymentInitial;
        int index = state.tariff.indexWhere((element) => element.id == state.selectedTariff);
        TariffDetail selectedTariff = state.tariff[index];
        double globalSize = MediaQuery.of(context).size.width - 32;

        return SafeArea(
          top: false,
          right: false,
          left: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              labelBuilder(context, state, index: state.selectedTariff!),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                    color: Colors.transparent,
                    width: (index == 0)
                        ? 0.0
                        : ((globalSize / state.tariff.length) * index).toDouble(),
                    height: 2.0,
                  ),
                  Flexible(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      width: globalSize / state.tariff.length,
                      height: 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: selectedTariff.isPromotion,
                      child: Text(
                        LocaleKeys.paymentScreen_promo.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                          color: const Color.fromARGB(255, 0, 207, 145),
                        ),
                      ),
                    ),
                    Text(
                      LocaleKeys.paymentScreen_tariffDescription.tr()
                          + " " + LocaleKeys.paymentScreen_monthsCount.plural(selectedTariff.period ~/ 30),
                      style: const TextStyle(
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color.fromRGBO(117,117,117,1),
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          selectedTariff.displayedPrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                            color: const Color.fromARGB(255, 0, 207, 145),
                          ),
                        ),
                        Visibility(
                          visible: selectedTariff.previousPrice != 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8,),
                              Text(
                                selectedTariff.displayedPreviousPrice + " ",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "/ " + LocaleKeys.paymentScreen_daysCount.plural(selectedTariff.period),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color.fromRGBO(117,117,117,1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    textItem(str: LocaleKeys.paymentScreen_feature1.tr()),
                    const SizedBox(height: 8,),
                    textItem(str: LocaleKeys.paymentScreen_feature2.tr()),
                    const SizedBox(height: 8,),
                    textItem(str: LocaleKeys.paymentScreen_feature3.tr()),
                    const SizedBox(height: 8,),
                    textItem(str: LocaleKeys.paymentScreen_feature4.tr()),
                  ],
                ),
              )

            ],
          ),
        );
      }
    );
  }

  Widget labelBuilder(BuildContext context, PaymentInitial state, {required int index})
  {
    List<Widget> list = [];
    for(final item in state.tariff)
    {
      list.add(
        Flexible(
          flex: 1,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: (){
              context.read<PaymentBloc>().add(
                SelectTariff(
                  index: item.id
                )
              );
            },
            child: SizedBox(
              height: 38,
              child: Center(
                child: Text(
                  LocaleKeys.paymentScreen_monthsCount.plural(item.period ~/ 30),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: (index == item.id)
                      ? const Color.fromRGBO(0, 0xcf, 0x91, 1)
                      : const Color.fromRGBO(110, 122, 145, 1),
                  ),
                ),
              ),
            ),
          ),
        )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }

  Widget textItem({required String str})
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Flexible(
          flex: 1,
          child: Icon(
            Icons.check,
            size: 24,
            color: Color.fromRGBO( 0, 207, 145, 1),
          )
        ),
        const SizedBox(width: 8,),
        Flexible(
          flex: 8,
          child: Text(
            str,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              height: 1.4,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color.fromRGBO(117,117,117,1),
            ),
          ),
        )
      ],
    );
  }

  Future<void> showPaymentMethodsDialog(
      BuildContext mainContext,
      PaymentInitial state
  ) {
    return showDialog(
      context: mainContext,
      builder: (dialogContext) {
        _emailForReceiptController.text = (state).emailForReceipt;
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          //elevation: 16,
          child: BlocProvider.value(
            value: BlocProvider.of<PaymentBloc>(mainContext),
            child: BlocBuilder<PaymentBloc, PaymentState>(
              bloc: mainContext.read<PaymentBloc>(),
              builder: (context, state) {
                return BlocListener<PaymentBloc, PaymentState>(
                  listener: (_, state) {
                    if ((state as PaymentInitial).pageState == PageState.buyValidation
                        || (state).pageState == PageState.buyError
                        || (state).pageState == PageState.buyWaiting
                    ) {
                      Navigator.pop(dialogContext);
                      state;
                      if (state.pageState == PageState.buyValidation) {
                        if (state.paymentMethod == PaymentMethod.card) {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CustomWebView(
                                    initialUrl: state.paymentRedirectUrl ?? "",
                                    header: "",
                                  )
                              )
                          ).then((value) {
                            mainContext.read<PaymentBloc>().add(const SuccessPurchaseEvent());
                          });
                        }
                      }
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LocaleKeys.paymentScreen_paymentMethod.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 18,),
                          Visibility(
                            visible: Platform.isIOS,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    context.read<PaymentBloc>().add(const SetPaymentMethodEvent(
                                        paymentMethod: PaymentMethod.applePay
                                    ));
                                  },
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: (state as PaymentInitial).paymentMethod == PaymentMethod.applePay
                                              ? const Color.fromARGB(255, 77, 222, 178)
                                              : const Color.fromARGB(255, 218, 216, 215),
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            'assets/icons/apple_pay_logo.png',
                                            height: 18,
                                          ),
                                          Visibility(
                                            visible: (state).paymentMethod == PaymentMethod.applePay,
                                            child: const Icon(
                                              Icons.check,
                                              color: Color.fromARGB(255, 77, 222, 178)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12,),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              context.read<PaymentBloc>().add(const SetPaymentMethodEvent(
                                  paymentMethod: PaymentMethod.card
                              ));
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (state).paymentMethod == PaymentMethod.card
                                      ? const Color.fromARGB(255, 77, 222, 178)
                                      : const Color.fromARGB(255, 218, 216, 215),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.credit_card_rounded,
                                          color: Color.fromARGB(255, 0, 207, 145),
                                        ),
                                        const SizedBox(width: 4,),
                                        Text(
                                          LocaleKeys.paymentScreen_paymentMethodCard.tr(),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.rubik(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: (state).paymentMethod == PaymentMethod.card,
                                      child: const Icon(
                                          Icons.check,
                                          color: Color.fromARGB(255, 77, 222, 178)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12,),
                          Visibility(
                            visible: (state).paymentMethod == PaymentMethod.card,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.paymentScreen_emailForReceiptTitle.tr(),
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: const Color.fromARGB(255,0,0,0),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _emailForReceiptController,
                                  onChanged: (emailForReceipt){
                                    context.read<PaymentBloc>().add(
                                        SetEmailForReceiptEvent(
                                            emailForReceipt: emailForReceipt
                                        )
                                    );
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 218, 216, 215),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText: LocaleKeys.entering_recoveryBy_email_hint.tr(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 0, 207, 145),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4,),
                                Visibility(
                                    visible: (state).emailForReceiptError != null,
                                    child: Text(
                                      (state).emailForReceiptError ?? "",
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    )
                                ),
                                const SizedBox(height: 12,),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: buildPaymentButton(context, state),
                          ),
                          // BlocProvider.value(
                          //   value: context.read<PaymentBloc>(),
                          //   child: buildPaymentButton(context, state as PaymentInitial)
                          // ),
                        ],
                      ),
                    ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorPaymentDialog(
    BuildContext context,
    PaymentInitial state
  ) async {
    String errorDetail = "";
    switch (state.errorCode) {
      case 0:
        errorDetail = LocaleKeys.paymentScreen_error_unknown.tr();
        break;
      case 1:
        errorDetail = LocaleKeys.paymentScreen_error_clientInvalid.tr();
        break;
      case 2:
        errorDetail = LocaleKeys.paymentScreen_error_paymentCancelled.tr();
        break;
      case 3:
        errorDetail = LocaleKeys.paymentScreen_error_paymentInvalid.tr();
        break;
      case 4:
        errorDetail = LocaleKeys.paymentScreen_error_paymentNotAllowed.tr();
        break;
      case 5:
        errorDetail = LocaleKeys.paymentScreen_error_storeProductNotAvailable.tr();
        break;
      case 6:
        errorDetail =  LocaleKeys.paymentScreen_error_cloudServicePermissionDenied.tr();
        break;
      case 7:
        errorDetail = LocaleKeys.paymentScreen_error_cloudServiceNetworkConnectionFailed.tr();
        break;
      case 8:
        errorDetail = LocaleKeys.paymentScreen_error_cloudServiceRevoked.tr();
        break;
      case 9:
        errorDetail = LocaleKeys.paymentScreen_error_privacyAcknowledgementRequired.tr();
        break;
      case 10:
        errorDetail = LocaleKeys.paymentScreen_error_unauthorizedRequestData.tr();
        break;
      case 11:
        errorDetail = LocaleKeys.paymentScreen_error_invalidOfferIdentifier.tr();
        break;
      case 12:
        errorDetail = LocaleKeys.paymentScreen_error_invalidSignature.tr();
        break;
      case 13:
        errorDetail = LocaleKeys.paymentScreen_error_missingOfferParams.tr();
        break;
      case 14:
        errorDetail = LocaleKeys.paymentScreen_error_invalidOfferPrice.tr();
        break;
      case 422:
        errorDetail = LocaleKeys.paymentScreen_error_verifyError.tr();
        break;
      case 500:
        errorDetail = LocaleKeys.paymentScreen_error_verifyAppStoreError.tr();
        break;
      case -1:
        errorDetail = LocaleKeys.paymentScreen_error_duplicateProductObject.tr();
        break;
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          //elevation: 16,
          child: BlocProvider.value(
            value: BlocProvider.of<PaymentBloc>(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LocaleKeys.paymentScreen_error_title.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    errorDetail,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color.fromARGB(
                          255, 117, 117, 117),
                    ),
                  ),
                  const SizedBox(height: 18,),
                  GestureDetector(
                    onTap: (){
                      context.read<PaymentBloc>().add(const CancelPurchaseEvent());
                      Navigator.pop(context, true);
                    },
                    child: Text(
                      LocaleKeys.paymentScreen_error_closeButton.tr(),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromARGB(
                            255, 77, 222, 178),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

