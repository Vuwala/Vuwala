import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vuwala/Booking%20Screens/HairstylistScreen.dart';
import '../CachedImageContainer.dart';
import '../Constants.dart';
import '../ViewScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    ['hair.png', 'Hairstylists'],
    ['makeup.png', 'Make-Up'],
    ['weight.png', 'Weight-Loss'],
    ['helth.png', 'Holistic-Health'],
  ];
  List category = [];
  List category1 = [];
  List category11 = [];
  @override
  void initState() {
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
    await homeScreen();
  }

  var token;
  getToken00() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  Dio dio = Dio();

  void homeScreen() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/vuwala_home_screen",
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
            category = jsonData['data']['category'];
            category1 = jsonData['data']['category_service'];
            category11 = jsonData['data']['category_service'][0]['services'];
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

  List ImageList = [
    "images/Group 62487.png",
    "images/Group 62488.png",
    "images/Group 62489.png",
    "images/Group 62490.png",
    "images/Group 62476.png",
    "images/Group 62477.png",
    "images/Group 62478.png",
    "images/Group 62491.png",
  ];

  var _saving = false;
  var baseurl = "http://159.223.181.226/vuwala/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _saving,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Image(image: AssetImage('images/Vuwala.png'), height: 60),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Top Categories',
                    style: TextStyle(
                      fontFamily: 'regular',
                      fontSize: 15.0,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 125,
                  child: ListView.builder(
                    itemCount: category.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewScreen(
                                Service: category1[index]["services"],
                                categoryName: category1[index]["category_name"],
                                Category: category1[index]['category_id'],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  ImageList[index],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  category[index]['category_name'] ?? ''.toString() ?? '',
                                  style: TextStyle(fontFamily: 'regular', fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      itemCount: category1.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      // 'hairstyle',
                                      category1[index]['category_name'] ?? ''.toString() ?? '',
                                      style: TextStyle(
                                        fontFamily: 'regular',
                                        fontSize: 15.0,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewScreen(
                                              Service: category1[index]["services"],
                                              categoryName: category1[index]["category_name"],
                                              Category: category1[index]['category_id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'View more',
                                        style: TextStyle(
                                          fontFamily: 'regular',
                                          fontSize: 12.0,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 250,
                              child: category1[index]["services"].length != 0
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: false,
                                      itemCount: category1[index]["services"].length,
                                      itemBuilder: (BuildContext context, int index1) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HairstyleListScreen(
                                                        serviceId: category1[index]["services"][index1]['service_id'] ?? '',
                                                        serviceName: category1[index]["services"][index1]['service_name'] ?? '',
                                                        ServicePrice: category1[index]["services"][index1]['service_price'] ?? '',
                                                        avgRate: category1[index]["services"][index1]['avg_rating'] ?? '',
                                                        sumRate: category1[index]["services"][index1]['sum_rating'] ?? '',
                                                        bName: category1[index]["services"][index1]['business_name'] ?? '',
                                                        bAddress: category1[index]["services"][index1]['business_address'] ?? '',
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 5.0,
                                                      ),
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(top: 5.0, right: 15, bottom: 2),
                                                  width: 280.0,
                                                  child: Column(
                                                    children: [
                                                      category1[index]["services"][index1]['service_thumbnail'] == null || category1[index]["services"][index1]['service_thumbnail'] == "null" || category1[index]["services"][index1]['service_thumbnail'] == ""
                                                          ? Image.asset(
                                                              'images/Group 62509.png',
                                                              height: 150,
                                                              width: MediaQuery.of(context).size.width,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : CachedImageContainer(
                                                              image: '$baseurl/${category1[index]["services"][index1]['service_thumbnail'] ?? ' fkdlb'}',
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 150,
                                                              topCorner: 6,
                                                              bottomCorner: 6,
                                                              fit: BoxFit.cover,
                                                              placeholder: 'images/Group 62509.png',
                                                            ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          category1[index]["services"][index1]['service_name'] ?? '',
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            fontFamily: 'regular',
                                                                            fontSize: 15.0,
                                                                            color: Color(0xff000000),
                                                                          ),
                                                                        ),
                                                                        Icon(Icons.star, color: Color(0xffFEC007)),
                                                                        Text(
                                                                          '${category1[index]["services"][index1]['avg_rating'] ?? ''}(${category1[index]["services"][index1]['sum_rating'] ?? ''})',
                                                                          style: TextStyle(
                                                                            fontFamily: 'regular',
                                                                            fontSize: 10.0,
                                                                            color: Color(0xffADADAD),
                                                                          ),
                                                                        ),
                                                                        Spacer(),
                                                                        Text(
                                                                          '\$${category1[index]["services"][index1]['service_price'] ?? ''}' ?? '',
                                                                          style: TextStyle(fontSize: 17, fontFamily: 'Bold', color: Color(0xff272627)),
                                                                          maxLines: 1,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    category1[index]["services"][index1]['business_name'] ?? '',
                                                                    style: TextStyle(fontSize: 10, fontFamily: 'regular', color: Color(0xff272627)),
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                  Text(
                                                                    category1[index]["services"][index1]['business_address'] ?? '',
                                                                    textAlign: TextAlign.start,
                                                                    style: TextStyle(fontSize: 10, fontFamily: 'regular', color: Color(0xff272627)),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : Container(
                                      height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: Text('No Data Found'),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
