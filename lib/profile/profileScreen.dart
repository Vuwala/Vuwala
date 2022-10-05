import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vuwala/Ongoing%20Screens/MyBookingScreen.dart';
import '../CachedImageContainer.dart';
import '../Constants.dart';
import '../InitialData.dart';
import '../LoginScreens/loginScreen.dart';
import '../PaymentMethodScreen.dart';
import 'ChangePassword.dart';
import 'ProfileInfotmation.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({Key key}) : super(key: key);

  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  List Listname = [];
  var token;

  @override
  void initState() {
    Listname.add('My Bookings');
    Listname.add('My Profile');
    Listname.add('Change Password');
    Listname.add('Payment Methods');
    ankit();
    super.initState();
  }

  FutureOr onGoBack(dynamic value) {
    editProfile();
    setState(() {});
  }

  ankit() async {
    await getToken11();
    await editProfile();
  }

  getToken11() async {
    token = await getToken();
  }

  var deviceID;
  var jsonData;
  var user_token;

  Dio dio = Dio();
  void logout() async {
    InitialData ankit = InitialData();
    await ankit.getDeviceTypeId();
    setState(() {
      deviceID = ankit.deviceID;
    });

    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/logout",
        options: Options(
          headers: {"authorization": 'Bearer $token'},
        ),
        data: {
          'device_id': deviceID.toString(),
        },
      );

      if (response.statusCode == 200) {
        await clearPrefData(key: 'user_token');
        await clearPrefData(key: 'device_id');
        await socialMediaSignOut();
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginScreen()));
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

  var profileData;
  String firstname, lastname, email1, profile, stripe_customer_id;
  void editProfile() async {
    setState(() {
      isProfile = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/edit_profile",
        data: {
          'user_type': 1,
        },
        options: Options(
          headers: {"authorization": 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        print(response);
        setState(() {
          jsonData = jsonDecode(response.toString());
          firstname = jsonData['data']['first_name'];
          lastname = jsonData['data']['last_name'];
          email1 = jsonData['data']['email'];
          profile = jsonData['data']['profile_pic'];
        });
        print(profileData);
        if (jsonData['status'] == 1) {
          setState(() {
            stripe_customer_id = jsonData['data']['stripe_customer_id'];
            isProfile = false;
          });
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        isProfile = false;
      });
      print(e.message);
      print(e.response);
    }
  }

  bool isProfile = false;

  var baseurl = "http://159.223.181.226/vuwala/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: isProfile,
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  Center(child: Container(margin: EdgeInsets.only(top: 20.0), height: 50.0, child: Text('Profile', style: TextStyle(fontSize: 22, fontFamily: 'medium', color: Color(0xff69a5a8))))),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        // border: Border.all(color: Colors.grey.),
                        boxShadow: [
                          BoxShadow(
                            // offset: Offset(2, 2),
                            color: Colors.grey[400],
                            blurRadius: 2.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80.0,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        children: [
                          profile == null || profile == "null" || profile == ""
                              ? Image.asset(
                                  'images/Group 62509.png',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                              : CachedImageContainer(
                                  image: '$baseurl/${profile ?? ' fkdlb'}',
                                  width: 80,
                                  height: 80,
                                  topCorner: 6,
                                  bottomCorner: 6,
                                  fit: BoxFit.fitWidth,
                                  placeholder: 'images/Group 62509.png',
                                ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${firstname ?? ''} ${lastname ?? ''}',
                                  style: TextStyle(fontSize: 17, fontFamily: 'bold', color: Color(0xff393938)),
                                ),
                                Text(
                                  '${email1 ?? ''}',
                                  style: TextStyle(fontSize: 13, fontFamily: 'regular', color: Color(0xff959594)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 17),
                      child: ListView.builder(
                        itemCount: Listname.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return HomeTile(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyBookingScreen()),
                                );
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => profileInformation()),
                                ).then((onGoBack));
                              } else if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => changePassword()),
                                );
                              } else if (index == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentMethodScreen(
                                            Email: jsonData['data']['email'],
                                            Coustomerid: stripe_customer_id,
                                          )),
                                );
                              }
                            },
                            index: index,
                            title: Listname[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  logout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                  child: Container(
                    height: 45.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xffd64343),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tab(
                          icon: Image.asset(
                            "images/an_Icon feather-log-out.png",
                            height: 20.0,
                            width: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          ' Logout',
                          style: TextStyle(fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final int index;

  HomeTile({this.onTap, this.title, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            // border: Border.all(color: Colors.grey),
            boxShadow: [
              BoxShadow(
                // offset: Offset(2, 2),
                color: Colors.grey[400],
                blurRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 45,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'PoppinsRegular',
                    color: Color(0xff262526),
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                'images/an_Iconarrow-back.png',
                height: 13,
                width: 13,
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
