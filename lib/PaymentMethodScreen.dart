import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vuwala/Booking%20Screens/AddNewCardScreen.dart';
import 'Constants.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Email;
  final Coustomerid;

  PaymentMethodScreen({this.Email, this.Coustomerid});
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selectCard = 1;

  void onSelect(int value) {
    setState(() {
      selectCard = value;
    });
  }

  Dio dio = Dio();
  var cardResponse;
  var cardJsonData;
  var deleteResponse;
  var deleteData;
  List cardListData = [];
  var UserToken;
  var listOflength;
  bool islist = false;

  var chargeResponse;
  var chargeData;

  bool isCharge = false;
  var token;
  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    UserToken = await box.read('userToken');
    setState(() {
      token = UserToken;
    });
    listOfCard();
  }

  deleteCard(String cardid) async {
    SharedPreferences userToken = await SharedPreferences.getInstance();
    UserToken = await userToken.getString('user_token');

    try {
      deleteResponse = await dio.post("http://159.223.181.226/vuwala/api/delete_card",
          data: {
            "card_id": cardid,
            "stripe_customer_id": widget.Coustomerid,
          },
          options: Options(headers: {"Authorization": "Bearer $UserToken"}));
      print(deleteResponse);
      deleteData = jsonDecode(deleteResponse.toString());
      print(deleteData);
      if (deleteData["status"] == 1) {
        Navigator.pop(context);
        Toasty.showtoast(deleteData["message"]);
      } else {
        Toasty.showtoast(deleteData["message"]);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
    }
  }

  listOfCard() async {
    print(token);
    try {
      cardResponse = await dio.post(
        "http://159.223.181.226/vuwala/api/list_all_cards",
        data: {},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      cardJsonData = jsonDecode(cardResponse.toString());
      if (cardJsonData["status"] == 1) {
        setState(() {
          islist = false;
          cardListData = cardJsonData['data']['data'];
        });
      }
    } on DioError catch (e) {
      setState(() {
        islist = false;
      });
      print(e.response);
      print(e.message);
    }
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  FutureOr onGoBack(dynamic value) {
    listOfCard();
    setState(() {});
  }

  var Selected;
  var id;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Payment Method',
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
        inAsyncCall: islist,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: cardListData.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: GestureDetector(
                            onLongPress: () {
                              print(cardListData[index]["stripe_card_id"]);
                              print(cardListData[index]["stripe_customer_id"]);
                            },
                            onTap: () {
                              setState(() {
                                Selected = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 0.4)], borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 10),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/atm-card.png',
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("${cardListData[index]['card_name'] ?? ""}", style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '**** **** ${cardListData[index]['last4'].toString()}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                            content: Container(
                                                height: 160,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(color: Color(0xff3AEBB4).withOpacity(0.4), shape: BoxShape.circle),
                                                      child: Center(
                                                        child: Image.asset(
                                                          "images/Delete-1.png",
                                                          height: 25,
                                                        ),
                                                      ),
                                                    ),
                                                    // SizedBox(height: 5),
                                                    Text(
                                                      'Are You Sure Delete This Card?',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Container(
                                                            height: height * 0.04,
                                                            width: width * 0.3,
                                                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(8)),
                                                            child: Center(
                                                              child: Text(
                                                                "cancel",
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width * 0.02,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            deleteCard(
                                                              cardListData[index]["id"],
                                                            );
                                                          },
                                                          child: Container(
                                                              height: height * 0.04,
                                                              width: width * 0.3,
                                                              decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                    colors: [
                                                                      Color(0xff3AEBB4),
                                                                      Color(0xff51BFE0),
                                                                    ],
                                                                  ),
                                                                  border: Border.all(color: Colors.white),
                                                                  borderRadius: BorderRadius.circular(8)),
                                                              child: Center(
                                                                child: Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ).then((onGoBack));
                                      },
                                      child: Image.asset(
                                        "images/Delete-1.png",
                                        color: Colors.grey,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddNewCardScreen(
                                Email: widget.Email,
                              ),
                            )).then((onGoBack));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                              '+ Add payment method',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff1a9390),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}
