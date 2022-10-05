import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vuwala/Booking%20Screens/BookAppointment.dart';
import '../CachedImageContainer.dart';
import '../Constants.dart';
import 'AboutScreen.dart';
import 'ReviweScreen.dart';

class SalonServicesScreen extends StatefulWidget {
  final bID;
  SalonServicesScreen({this.bID});
  @override
  _SalonServicesScreenState createState() => _SalonServicesScreenState();
}

class _SalonServicesScreenState extends State<SalonServicesScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    ankit();
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  ankit() async {
    await getToken00();
    await get_business_details();
  }

  var token;

  getToken00() async {
    token = await getToken();
  }

  var businessId;
  var businessID;
  Future getBusinessId1() async {
    businessId = await getPrefData(key: 'business_id');
    setState(() {
      businessID = businessId;
    });
  }

  var jsonData;
  var bname;
  var badress;
  var avg;
  var sum;

  Dio dio = Dio();
  var data;
  var info, phone, web;
  var profile;

  void get_business_details() async {
    businessId = await getPrefData(key: 'business_id');
    setState(() {
      businessID = businessId;
    });
    setState(() {});
    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/get_business_details",
        data: {'business_id': widget.bID},
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
            Service = jsonData['data']['services'];
            Service1 = jsonData['data']['review'];
            data = jsonData;
            avg = jsonData['data']['avg_rating'].toString();
            sum = jsonData['data']['sum_rating'].toString();
            bname = jsonData['data']['business_name'].toString();
            badress = jsonData['data']['business_address'].toString();
            info = jsonData['data']['business_information'].toString() ?? '';
            phone = jsonData['data']['phone_number'].toString() ?? '';
            web = jsonData['data']['business_web'].toString() ?? '';
            profile = jsonData['data']['business_thumbnail'];
          });
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _saving = false;
          });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    profile == null || profile == "null" || profile == ""
                        ? Image.asset(
                            'images/Group 62509.png',
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          )
                        : CachedImageContainer(
                            image: '$baseurl/${profile ?? ''}',
                            topCorner: 0,
                            bottomCorner: 0,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            placeholder: 'images/Group 62509.png',
                          ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 30.0,
                          margin: EdgeInsets.only(left: 25.0, top: 15.0, bottom: 10.0),
                          child: Image(
                            image: AssetImage('images/Icon ionic-ios-arrow-round-back.png'),
                            color: Colors.white,
                            height: 22.0,
                            width: 28.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 15.0),
                        height: 30.0,
                        child: Text(
                          bname ?? "",
                          style: TextStyle(fontSize: 17, fontFamily: 'medium', color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        bname ?? "",
                        style: TextStyle(fontSize: 16, fontFamily: 'medium', color: Color(0xff272627)),
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'images/star.png',
                        height: 15,
                      ),
                      SizedBox(width: 5),
                      Text('${avg ?? ""}(${sum ?? ""})', style: KStarReviewStyle),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    badress ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 13, fontFamily: 'medium', color: Color(0xff272627)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: TabBar(
                unselectedLabelColor: Colors.black45,
                labelPadding: EdgeInsets.symmetric(horizontal: 3),
                indicatorColor: Colors.white70,
                labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'medium'),
                unselectedLabelStyle: TextStyle(color: Color(0xff959594)),
                tabs: [Tab(child: Text('Service', style: KTabBarStyle)), Tab(child: Text('About', style: KTabBarStyle)), Tab(child: Text('Review', style: KTabBarStyle))],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Colors.black,
                height: 2,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ServiceScreen(),
                  AboutScreen(
                    information: info,
                    phoneNo: phone,
                    webName: web,
                  ),
                  ReviewScreen(),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List About = [];
List Service = [];
List Service1 = [];

class ServiceScreen extends StatelessWidget {
  final img;
  final about;
  final rating;
  final ratingCount;
  final time;
  final price;
  final jsonData;
  final bname;
  final badress;
  final avg;
  final sum;

  const ServiceScreen({Key key, this.img, this.about, this.rating, this.ratingCount, this.time, this.price, this.jsonData, this.bname, this.badress, this.avg, this.sum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: Service.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return ServiceTile(
                index: index,
                ServiceName: Service[index]["service_name"],
                price: '${Service[index]["service_price"]}',
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookAppointmentScreen(
                              title: bname ?? "",
                              about: about ?? "",
                              img: jsonData['data']['business_thumbnail'],
                              price: sum,
                            )));
              },
              child: Text(
                'Book Appointment',
                style: KButtonStyle,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

var baseurl = "http://159.223.181.226/vuwala";

class ServiceTile extends StatefulWidget {
  final ServiceName, price;
  final Function onTap;
  final int index;
  const ServiceTile({this.ServiceName, this.price, this.index, this.onTap});

  @override
  _ServiceTileState createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
        });
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 5),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Service[widget.index]['service_thumbnail'] == null || Service[widget.index]['service_thumbnail'] == "null" || Service[widget.index]['service_thumbnail'] == ""
                        ? Image.asset(
                            'images/Group 62509.png',
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          )
                        : CachedImageContainer(
                            image: '$baseurl/${Service[widget.index]['service_thumbnail'] ?? ' fkdlb'}',
                            width: 70,
                            height: 70,
                            topCorner: 6,
                            bottomCorner: 6,
                            fit: BoxFit.cover,
                            placeholder: 'images/Group 62509.png',
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ServiceName,
                            style: TextStyle(fontSize: 14, fontFamily: 'medium'),
                          ),
                          Text(
                            widget.price,
                            style: TextStyle(fontSize: 15, fontFamily: 'bold'),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        height: 22,
                        child: value ? Image.asset('images/check-mark.png') : Image.asset('images/check-mark-1.png'),
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
  }
}
