import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:vuwala/customtextfiled.dart';
import '../Constants.dart';

class AddNewCardScreen extends StatefulWidget {
  final Email;

  AddNewCardScreen({this.Email});
  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController validity = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();
  FlipCardController cardController = FlipCardController();

  var UserEmail;
  var Customerid;

  @override
  void initState() {
    setState(() {
      UserEmail = widget.Email;
      print(UserEmail);
    });
    super.initState();
    StripePayment.setOptions(StripeOptions(publishableKey: "pk_test_51KLfwcH9fBHEBjmrLIGShGYP8dLOSMLCf2HAjfH3bdBfsHozHQzRwXzlENwO9KvOTuz1rFtDNeNSNh1elcPV8Ec200Dd2EdaxW", androidPayMode: 'test'));
  }

  var AddResponse;
  var AddJsonData;
  var UserToken;
  var Customer_id;
  Dio dio = Dio();
  AddCard() async {
    UserToken = await box.read('userToken');
    print(UserToken);

    try {
      AddResponse = await dio.post(
        "http://159.223.181.226/vuwala/api/add_card",
        data: {
          'name': "${cardHolderName.text}",
          'number': cardNumber.text,
          'month': validity.text.split("/")[0],
          'year': validity.text.split("/")[1],
          'email': UserEmail.toString(),
          'date': cvv.text,
        },
        options: Options(
          headers: {"Authorization": "Bearer $UserToken"},
        ),
      );

      print(AddResponse);
      AddJsonData = jsonDecode(AddResponse.toString());
      print(AddJsonData);
      if (AddJsonData['status'] == 1) {
        setData();
        setState(() {
          addcard = false;
        });
        Toasty.showtoast('Card Added Successfully');
        Navigator.pop(context);
      } else if (AddJsonData['status'] == 0) {
        Toasty.showtoast('Enter Valid Card Detail');
        setState(() {
          addcard = false;
        });
      }
    } on DioError catch (e) {
      setState(() {
        addcard = false;
      });
      print(e.message);
      print(e.response.statusCode);
    }
  }

  setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("CustomerId", AddJsonData['data']["customer"]);
  }

  bool addcard = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Add New Card',
            style: KAppbarStyle,
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'images/Icon ionic-ios-arrow-round-back.png',
                  cacheHeight: 18,
                ),
              );
            },
          ),
        ),
        body: ModalProgressHUD(
          opacity: 0,
          inAsyncCall: addcard,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: FlipCard(
                      key: cardKey,
                      front: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Image.asset('images/Group 62494.png'),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(cardNumber.text.isNotEmpty ? cardNumber.text : '0000 0000 0000 0000', style: TextStyle(color: Colors.white, fontSize: 25))),
                                Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      // color: Colors.grey.shade800.withOpacity(0.5),
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Cardholder Name", style: TextStyle(color: Colors.white, fontSize: 12)),
                                            SizedBox(height: 3),
                                            Text(cardHolderName.text.isNotEmpty ? cardHolderName.text : "Cardholder Name", style: TextStyle(color: Colors.white, fontSize: 22)),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Exp Date", style: TextStyle(color: Colors.white, fontSize: 12)),
                                            SizedBox(height: 3),
                                            Text(validity.text.isNotEmpty ? validity.text : "00/00", style: TextStyle(color: Colors.white, fontSize: 22)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      back: Stack(
                        children: [
                          Image.asset('images/Group 62507.png'),
                          Padding(
                            padding: EdgeInsets.only(top: 120),
                            child: Stack(
                              children: [
                                Container(decoration: BoxDecoration(color: Colors.white), height: 50, width: double.infinity),
                                Positioned(
                                  child: Row(
                                    children: [
                                      Container(decoration: BoxDecoration(color: Colors.black), height: 50, width: MediaQuery.of(context).size.width * 0.7),
                                      SizedBox(width: 10),
                                      Text(cvv.text.isNotEmpty ? cvv.text : "000", style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  CostumeTextFiled(
                      input: TextInputType.number,
                      controller: cardNumber,
                      hintText: '0000 0000 0000 0000',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, CustomInputFormatter(), LengthLimitingTextInputFormatter(19)],
                      onChanged: (number) {
                        print(number);
                        setState(() {
                          cardNumber
                            ..text = number
                            ..selection = TextSelection.collapsed(offset: cardNumber.text.length);
                        });
                      },
                      text: 'Card Number',
                      isShow: false),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CostumeTextFiled(
                            input: TextInputType.number,
                            controller: validity,
                            text: 'Valid Thru(MM/YY)',
                            hintText: '00/00',
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, _birthDate, LengthLimitingTextInputFormatter(5)],
                            onChanged: (date) {
                              setState(() {
                                validity
                                  ..text = date
                                  ..selection = TextSelection.collapsed(offset: validity.text.length);
                              });
                            },
                            isShow: false),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: CostumeTextFiled(
                          input: TextInputType.number,
                          onChanged: (code) {
                            setState(() {
                              cvv
                                ..text = code
                                ..selection = TextSelection.collapsed(offset: cvv.text.length);
                            });
                          },
                          onTap: () {
                            cardController.toggleCard();
                          },
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                          controller: cvv,
                          text: 'CVV',
                          hintText: '000',
                          isShow: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CostumeTextFiled(
                      controller: cardHolderName,
                      text: 'Cardholder Name',
                      hintText: 'Cardholder Name',
                      onChanged: (name) {
                        setState(() {
                          cardHolderName
                            ..text = name
                            ..selection = TextSelection.collapsed(offset: cardHolderName.text.length);
                        });
                      },
                      isShow: false),
                  SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: kBoxDecoration,
                      child: TextButton(
                        onPressed: () async {
                          if (_validate(CardNme: cardHolderName.text, CardNumber: cardNumber.text, Cvv: cvv.text, valid: validity.text)) {
                            setState(() {
                              addcard = true;
                            });
                            await AddCard();
                          }
                        },
                        child: Text(
                          'Save',
                          style: KButtonStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _validate({String CardNumber, String CardNme, String valid, String Cvv}) {
  if (CardNumber.isEmpty && CardNme.isEmpty && valid.isEmpty && Cvv.isEmpty) {
    Toasty.showtoast('Please Enter Your Credentials');
    return false;
  } else if (CardNumber.isEmpty) {
    Toasty.showtoast('Please Enter Your Card Number');
    return false;
  } else if (CardNme.isEmpty) {
    Toasty.showtoast('Please Enter Valid Card Name');
    return false;
  } else if (valid.isEmpty) {
    Toasty.showtoast('Please Enter Your ExpiryDate');
    return false;
  } else if (Cvv.isEmpty) {
    Toasty.showtoast('Please Enter Your CVV');
    return false;
  } else {
    // Toasty.showtoast('Logged in Successfully');
    return true;
  }
}

final _UsNumberTextInputFormatter _birthDate = new _UsNumberTextInputFormatter();

class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '/');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 4) + '/');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(4, usedSubstringIndex = 8));
      if (newValue.selection.end >= 8) selectionIndex++;
    }
// Dump the rest.
    if (newTextLength >= usedSubstringIndex) newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: new TextSelection.collapsed(offset: string.length));
  }
}
