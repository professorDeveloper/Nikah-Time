import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/Profile/web_view_page.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/components/models/nikah_error.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/app_background_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/widgets/custom_appbar.dart';

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:untitled/generated/locale_keys.g.dart';

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../components/items/wrapped.dart';


part 'view/payment_view.dart';
part 'bloc/payment_bloc.dart';
part 'bloc/payment_event.dart';
part 'bloc/payment_state.dart';


enum PageState {
  hold,
  preload,
  loading,
  ready,
  error,
  noMoreItem,
  preBuyWaiting,
  buyWaiting,
  buyValidation,
  buySuccess,
  buyError,
}

class TariffDetail {
  final int id;
  final String? idOnStore;
  final String title;
  final String description;
  final int period;
  final double price;
  final double previousPrice;
  final String currencyCode;
  final String currencySymbol;
  final bool isUserTariff;
  final ProductDetails? detailsOnStore;
  final bool isPromotion;

  String get displayedPrice {
    return _getFormattedDouble(
        price,
        fractionalLength: 2
    ) + " $currencySymbol";
  }

  String get displayedPreviousPrice {
    return _getFormattedDouble(
        previousPrice,
        fractionalLength: 2
    ) + " $currencySymbol";
  }

  String _getFormattedDouble(
    double? value, {
    String digitSeparator = " ",
    String fractionSeparator = ",",
    int? fractionalLength,
    bool hasFractionalPad = true
  }) {
    if (value == null) {
      return "";
    }

    String integerPart = value.truncate().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}$digitSeparator');

    String fractionalPart = "";
    var split = value.toString().split('.');
    if (split.length > 1) {
      fractionalPart = split[1];
      if (fractionalPart != "0") {
        if (fractionalLength != null) {
          int substringLength = 0;
          if (fractionalPart.length > fractionalLength) {
            substringLength = fractionalLength;
          } else {
            substringLength = fractionalPart.length;
          }
          if (hasFractionalPad) {
            fractionalPart = fractionSeparator
                + fractionalPart.substring(0, substringLength).padRight(
                    fractionalLength, '0');
          } else {
            fractionalPart = fractionSeparator
                + fractionalPart.substring(0, substringLength);
          }
        } else {
          fractionalPart = fractionSeparator + fractionalPart;
        }
      } else {
        fractionalPart = "";
      }
    } else {
      fractionalPart = "";
    }

    return integerPart + fractionalPart;
  }

  TariffDetail({
    required this.id,
    this.idOnStore,
    required this.title,
    required this.description,
    required this.period,
    this.currencyCode = "RUB",
    this.currencySymbol = "₽",
    required this.price,
    required this.previousPrice,
    required this.isUserTariff,
    this.detailsOnStore,
    required this.isPromotion
  });

  factory TariffDetail.fromJson(Map<String, dynamic> json) => TariffDetail(
    id: json["id"] as int,
    title: json["title"] as String,
    description: json["description"] as String,
    period: json["period"] as int,
    price: (json["price"] as int).toDouble(),
    previousPrice: (json["previousPrice"] as int).toDouble(),
    isUserTariff: json["isUserTariff"] as bool,
    idOnStore: json["idOnStore"] as String?,
    isPromotion: json["isPromotion"] as bool,
  );

  TariffDetail copyThis({
    int? id,
      Wrapped<String?>? idOnStore,
      String? title,
      String? description,
      int? period,
      double? price,
      double? previousPrice,
      bool?   isPromotion,
      String? currencyCode,
      String? currencySymbol,
      bool? isUserTariff,
      Wrapped<ProductDetails?>? detailsOnStore
  }) {
    return TariffDetail(
        id: id ?? this.id,
        idOnStore: idOnStore != null ? idOnStore.value : this.idOnStore,
        title: title ?? this.title,
        description: description ?? this.description,
        period: period ?? this.period,
        price: price ?? this.price,
        currencyCode: currencyCode ?? this.currencyCode,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        isUserTariff: isUserTariff ?? this.isUserTariff,
        detailsOnStore: detailsOnStore != null ? detailsOnStore.value : this.detailsOnStore,
        previousPrice: previousPrice ?? this.previousPrice,
        isPromotion: isPromotion ?? this.isPromotion,
    );
  }
}

Future<void> showPaymentDialog(
  BuildContext context,
  {
    required String text,
  }
) async
{
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        //elevation: 16,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,//"Для просмотра необходимо иметь активную подписку",
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8,),
              Text(
                LocaleKeys.common_payment_alert_detail.tr(),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color.fromARGB(
                      255, 117, 117, 117),
                ),
              ),
              const SizedBox(height: 18,),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12.0),
                  ),
                  color: Color.fromARGB(255, 0, 207, 145),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaymentView(),
                      ),
                    ).then((value) => Navigator.pop(context));
                  },
                  child: Text(
                    LocaleKeys.common_payment_alert_moreButton.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context, true);
                },
                child: Text(
                  LocaleKeys.common_payment_alert_notNowButton.tr(),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromARGB(
                        255, 77, 222, 178),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget paymentStub(BuildContext context) {
  return Container(
    width: 328,
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.common_payment_alert_titleForView.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8,),
        Text(
          LocaleKeys.common_payment_alert_detail.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color.fromARGB(255, 117, 117, 117),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18,),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12.0),
            ),
            color: const Color.fromARGB(255, 0, 207, 145),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PaymentView(),
                ),
              );
            },
            child: Text(
              LocaleKeys.common_payment_alert_moreButton.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    )
  );
}