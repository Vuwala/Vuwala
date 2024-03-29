import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({
    this.message,
    this.success,
  });
}

class StripeServices {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
  static Uri paymentApiUri = Uri.parse(paymentApiUrl);
  static String secret = 'sk_test_51KLfwcH9fBHEBjmrSyzyyO8j7klikW3i4ToSmHvcKJPQN5TspqlemOdoT5UDcIozdmo91PRd9xE7Pvrr39ZzomrX00tW4wl5Ea';

  static Map<String, String> headers = {'Authorization': 'Bearer ${StripeServices.secret}', 'Content-Type': 'application/x-www-form-urlencoded'};

  static init() {
    StripePayment.setOptions(StripeOptions(publishableKey: 'pk_test_51KLfwcH9fBHEBjmrLIGShGYP8dLOSMLCf2HAjfH3bdBfsHozHQzRwXzlENwO9KvOTuz1rFtDNeNSNh1elcPV8Ec200Dd2EdaxW', androidPayMode: 'test', merchantId: 'test'));
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(paymentApiUri, headers: headers, body: body);
      print("${response.body}");
      print("response.body");
      return jsonDecode(response.body);
    } catch (error) {
      print('error Happened');
      throw error;
    }
  }

  static Future<StripeTransactionResponse> payNowHandler({String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      var paymentIntent = await StripeServices.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(clientSecret: paymentIntent['client_secret'], paymentMethodId: paymentMethod.id));

      if (response.status == 'succeeded') {
        return StripeTransactionResponse(message: 'Transaction succeful', success: true);
      } else {
        return StripeTransactionResponse(message: 'Transaction failed', success: false);
      }
    } catch (error) {
      return StripeTransactionResponse(message: 'Transaction failed in the catch block', success: false);
    }
  }

  static getErrorAndAnalyze(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction canceled';
    }
    return StripeTransactionResponse(message: message, success: false);
  }
}
