import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vuwala/Utils/Write_a_Review.dart';
import '../CachedImageContainer.dart';
import '../Constants.dart';

class MyBookingScreen extends StatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'My Booking',
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
          bottom: TabBar(
            onTap: (index) {},
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            indicatorWeight: 2,
            indicatorColor: Color(0xff1a9390),
            unselectedLabelColor: Color(0xff868686),
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'bold'),
            unselectedLabelStyle: TextStyle(color: Color(0xff868686)),
            tabs: [
              Tab(
                  child: Text(
                'Ongoing',
                style: KTabBarStyle,
              )),
              Tab(
                  child: Text(
                'Completed',
                style: KTabBarStyle,
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OngoingScreen(), //Tab 1
            CompletedScreen(), //Tab 2
          ],
        ),
      ),
    );
  }
}

class OngoingScreen extends StatefulWidget {
  @override
  _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  List ongoing1 = [];
  @override
  void initState() {
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
    await Ongoing();
  }

  var token;

  getToken00() async {
    token = await getToken();
  }

  var jsonData;
  var data;

  Dio dio = Dio();

  void Ongoing() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_booking_by_status",
        data: {
          'booking_status': 1,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response);
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
            ongoing1 = jsonData["data"];
          });
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var _saving = false;
  var baseurl = "http://159.223.181.226/vuwala";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _saving,
        child: ListView.builder(
          itemCount: ongoing1.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ongoing1[index]['service_thumbnail'] == null || ongoing1[index]['service_thumbnail'] == "null" || ongoing1[index]['service_thumbnail'] == ""
                        ? Image.asset(
                            'images/Group 62509.png',
                            height: 130,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : CachedImageContainer(
                            image: '$baseurl/${ongoing1[index]['service_thumbnail'] ?? ' fkdlb'}',
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            topCorner: 6,
                            bottomCorner: 6,
                            fit: BoxFit.cover,
                            placeholder: 'images/Group 62509.png',
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order Id:'
                                  '\#${ongoing1[index]['br_id'] ?? ''}',
                                  style: KOrderIdStyle,
                                ),
                                Spacer(),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '\$${ongoing1[index]['service_price'] ?? ''}',
                                    style: KBookingStyle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  ongoing1[index]['service_name'] ?? '',
                                  style: KBookingStyle,
                                ),
                                Spacer(),
                                Image.asset(
                                  'images/star.png',
                                  height: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${ongoing1[index]['avg_rating'] ?? ''}(${ongoing1[index]['sum_rating'] ?? ''})',
                                  style: KStarReviewStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              ongoing1[index]['business_name'] ?? '',
                              style: KTextStyle,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                ongoing1[index]['business_address'] ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: KTextStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color(0xff599a9a),
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[400],
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    ongoing1[index]['o_book_date'],
                                    style: TextStyle(fontSize: 15, fontFamily: 'medium', color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CompletedScreen extends StatefulWidget {
  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  Future showDialogReview(BuildContext context) async {
    await showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ReviewScreen(
            businessID: bId,
            serviceId: sId,
          ),
        );
      },
      animationType: DialogTransitionType.fadeScale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  List ongoing2 = [];
  @override
  void initState() {
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
    await Complete();
  }

  var token;

  getToken00() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  var bId, sId;
  Dio dio = Dio();

  void Complete() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_booking_by_status",
        data: {
          'booking_status': 2,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response);
        setState(() {
          jsonData = jsonDecode(response.toString());
          print('');
          print(jsonData);
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
            ongoing2 = jsonData["data"];
            bId = jsonData['data'][0]['business_id'];
            sId = jsonData['data'][0]['service_id'];
          });
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var _saving = false;
  var baseurl = "http://159.223.181.226/vuwala";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _saving,
        child: ListView.builder(
          itemCount: ongoing2.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ongoing2[index]['service_thumbnail'] == null || ongoing2[index]['service_thumbnail'] == "null" || ongoing2[index]['service_thumbnail'] == ""
                        ? Image.asset(
                            'images/Group 62509.png',
                            height: 130,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : CachedImageContainer(
                            image: '$baseurl/${ongoing2[index]['service_thumbnail'] ?? ' fkdlb'}',
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            topCorner: 6,
                            bottomCorner: 6,
                            fit: BoxFit.cover,
                            placeholder: 'images/Group 62509.png',
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order Id:'
                                  '\#${ongoing2[index]['br_id'] ?? ''}',
                                  style: KOrderIdStyle,
                                ),
                                Spacer(),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '\$${ongoing2[index]['service_price'] ?? ''}',
                                    style: KBookingStyle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  ongoing2[index]['service_name'] ?? '',
                                  style: KBookingStyle,
                                ),
                                Spacer(),
                                Image.asset(
                                  'images/star.png',
                                  height: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${ongoing2[index]['avg_rating'] ?? ''}(${ongoing2[index]['sum_rating'] ?? ''})',
                                  style: KStarReviewStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              ongoing2[index]['business_name'] ?? '',
                              style: KTextStyle,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                ongoing2[index]['business_address'] ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: KTextStyle,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                showDialogReview(context).then((value) {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Color(0xff599a9a),
                                    borderRadius: BorderRadius.circular(30.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    // onPressed: () {
                                    // },
                                    onPressed: () {},
                                    child: Text(
                                      'Write a Review',
                                      style: TextStyle(fontSize: 15, fontFamily: 'medium', color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
