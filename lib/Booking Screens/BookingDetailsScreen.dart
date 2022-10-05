import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vuwala/Booking%20Screens/AddNewCardScreen.dart';
import 'package:vuwala/Booking%20Screens/AppointmentSuccessfullyScreen.dart';
import '../Constants.dart';

class BookingDetailsScreen extends StatefulWidget {
  final img;
  final title;
  final about;
  final rating;
  final ratingCount;
  final time;
  final price;

  final customerid;
  final cardid;

  final int b1ID;
  final int sID;
  final uId;
  final sDate;

  const BookingDetailsScreen({this.customerid, this.cardid, this.img, this.title, this.about, this.rating, this.ratingCount, this.time, this.price, this.b1ID, this.sID, this.sDate, this.uId});
  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool islist = false;

  Dio dio = Dio();
  var cardResponse;
  var cardJsonData;
  List cardListData = [];
  bool isDelete = false;

  int Selected = 0;
  int selectCard = 1;
  var chargeResponse;
  var chargeData;
  var deleteResponse;
  var deleteData;
  bool isCharge = false;

  createCharge(String cardid) async {
    setState(() {
      isCharge = true;
    });
    UserToken = await box.read('userToken');
    try {
      chargeResponse = await dio.post(
        "http://159.223.181.226/vuwala/api/create_charge",
        data: {
          'service_id': widget.sID,
          'book_date': widget.sDate.toString(),
          'slot_id': '1',
          'payment_id': '1',
          'business_id': widget.b1ID,
          "card_id": cardid,
          "transaction_to": widget.uId,
          "id_type": 0,
          "transaction_note": 0,
          "transaction_type": 0,
          "payment_type": 0,
          "amount": widget.price,
        },
        options: Options(
          headers: {"Authorization": "Bearer $UserToken"},
        ),
      );
      print(chargeResponse);
      chargeData = jsonDecode(chargeResponse.toString());
      print(chargeData);
      if (chargeData["status"] == 1) {
        setState(() {
          isCharge = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentBookSuccessfully()));
        Toasty.showtoast(chargeData["message"]);
      } else {
        Toasty.showtoast(chargeData["message"]);
      }
    } on DioError catch (e) {
      setState(() {
        isCharge = false;
      });
      print(e.message);
      print(e.response);
    }
  }

  deleteCard(String cardid) async {
    final prefs = await SharedPreferences.getInstance();
    UserToken = await box.read('userToken');
    setState(() {
      token = UserToken;
    });
    print(UserToken);
    print("Token");

    try {
      deleteResponse = await dio.post("http://159.223.181.226/vuwala/api/delete_card",
          data: {
            "card_id": cardid,
          },
          options: Options(headers: {"Authorization": "Bearer $UserToken"}));
      print(deleteResponse);
      deleteData = jsonDecode(deleteResponse.toString());
      print(deleteData);
      if (deleteData["status"] == 1) {
        Navigator.pop(context);
        Toasty.showtoast(deleteData["message"]);
        Selected = 0;
        getToken();
      } else {
        Toasty.showtoast(deleteData["message"]);
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
    }
  }

  void onSelect(int value) {
    setState(() {
      selectCard = value;
    });
  }

  FutureOr onGoBack(dynamic value) {
    listOfCard();
    setState(() {});
  }

  var token;
  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    UserToken = await box.read('userToken');
    setState(() {
      token = UserToken;
    });
    listOfCard();
  }

  listOfCard() async {
    print('harsh');

    print(token);
    try {
      cardResponse = await dio.post(
        "http://159.223.181.226/vuwala/api/list_all_cards",
        data: {},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print("Response list of cards $cardResponse");
      cardJsonData = jsonDecode(cardResponse.toString());
      print(cardJsonData);
      if (cardJsonData["status"] == 1) {
        setState(() {
          islist = false;
          cardListData = cardJsonData['data']['data'];
          print(cardListData);
          print("list length ${cardListData.length}");
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
    print('init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Booking Details', style: KAppbarStyle),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontFamily: 'medium', color: Color(0xff69a5a8), fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCardScreen())).then((value) => getToken());
                  },
                  child: Text(
                    '+ Add others card',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff393938),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
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
                            Container(
                              padding: EdgeInsets.all(2.5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: Selected == index ? Color(0xff1a9390) : Colors.grey, width: 1),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Selected == index ? Color(0xff1a9390) : Colors.white),
                              ),
                            ),
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
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: kBoxDecoration,
                  child: TextButton(
                      onPressed: () {
                        if (cardListData.length != 0) {
                          print(Selected);
                          print(cardListData[Selected]["id"]);
                          createCharge(cardListData[Selected]["id"]);
                        } else {
                          Toasty.showtoast("Add card");
                        }
                      },
                      child: Text('Continue', style: KButtonStyle)))),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
