import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vuwala/HomeScreen/HomeScreen1.dart';
import 'package:vuwala/pageTransitionanimations.dart';
import '../Constants.dart';
import '../HomeScreen/HomeScreen.dart';
import '../InitialData.dart';
import 'ForgotScreen.dart';
import 'GoogleSignIn.dart';
import 'SignUpScreen.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String deviceToken;
  int deviceType;
  var deviceID;
  var jsonData;
  var user_token;
  int type;

  double latitude, longitude;
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
    print("latitude $latitude");
    print("longitude $longitude");
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Dio dio = Dio();

  login() async {
    InitialData ankit = InitialData();

    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      _saving = true;
      deviceToken = ankit.deviceToken;
      deviceID = ankit.deviceID;
      deviceType = ankit.deviceType;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/login",
        data: {
          'email': email.text,
          'password': password.text,
          'device_id': deviceID ?? '',
          'device_token': deviceToken ?? '',
          'device_type': deviceType ?? '',
          'user_type': 1,
          'lattitude': latitude ?? '0.00',
          'longitude': longitude ?? '0.00',
        },
      );
      if (response.statusCode == 200) {
        print(response);
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
            setUserData();
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen1()), (route) => false);
          Toasty.showtoast(jsonData['message']);
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
    } on DioError catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  final box = GetStorage();
  setUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', jsonData['data']['user_token']);
    await setPrefData(key: 'device_id', value: deviceID.toString());
    box.write('userToken', jsonData['data']['user_token'].toString());
    box.write('business_id', jsonData['data']['business_id'].toString());
    await setPrefData(key: 'business_id', value: jsonData['data']['business_id'].toString());
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future setisFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirst', false);
  }

  bool obscureText = true;
  @override
  void initState() {
    setisFirst();
    getCurrentLocation();
    super.initState();
  }

  void loginByThirdParty({
    String fgName,
    String fgEmail,
    String thirdPartyID,
    String profilePic,
    String loginType,
  }) async {
    InitialData ankit = InitialData();
    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      deviceToken = ankit.deviceToken;
      deviceID = ankit.deviceID;
      deviceType = ankit.deviceType;
    });
    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/login_by_thirdparty",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status <= 500;
            }),
        data: {
          'email': fgEmail ?? '',
          'thirdparty_id': thirdPartyID,
          'first_name': fgName,
          'login_type': loginType,
          'user_type': 1,
          'device_type': deviceType,
          'device_token': deviceToken,
          'device_id': deviceID,
          'lattitude': latitude ?? "0.00",
          'longitude': longitude ?? "0.00",
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await setUserData();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen1()), (Route<dynamic> route) => false);
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        } else {
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        setState(() {
          _saving = false;
        });
        Toasty.showtoast('Something Went Wrong');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var userData;
  Future<void> socialFBLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      userData = await FacebookAuth.instance.getUserData();
      print('FB LOGIN DATA >>>>>>>>>>>>>>>> ' + userData.toString());
      var fgName = userData['name'];
      var fgEmail = userData['email'];
      var thirdPartyID = userData['id'];
      var profilePhotoUrl = userData['picture']['data']['url'];

      if (thirdPartyID != null || thirdPartyID != '') {
        loginByThirdParty(fgName: fgName, fgEmail: fgEmail, thirdPartyID: thirdPartyID, loginType: '1', profilePic: profilePhotoUrl);
        print('Facebook Logged In');
        print('STATUS Success>>>>>>>>>>>>>>>> ' + result.status.toString());
      }
    } else {
      print('STATUS >>>>>>>>>>>>>>>> ' + result.status.toString());
      print('MESSAGE >>>>>>>>>>>>>>> ' + result.message);
    }
  }

  Future appleSignIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    return credential;
  }

  var _saving = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/bgo.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          opacity: 0,
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 90.0,
                            child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset('images/Vuwala.png', width: MediaQuery.of(context).size.width - 25),
                                ))),
                        Center(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Color(0xff69a6a8), fontSize: 30, fontFamily: 'medium'),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Please Login to continue',
                            style: TextStyle(color: Color(0xff403f41), fontSize: 12, fontFamily: 'medium'),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff9F9F9F)),
                        ),
                        SizedBox(height: 4),
                        Container(
                          decoration: kContainerDecoration,
                          child: TextField(
                            controller: email,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              errorBorder: kOutlineInputBorder,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Email",
                              hintStyle: TextStyle(fontSize: 15, fontFamily: 'Regular', color: Color(0xffB6B6B6)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'password',
                          style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff9F9F9F)),
                        ),
                        SizedBox(height: 4),
                        Container(
                            decoration: kContainerDecoration,
                            child: TextField(
                              controller: password,
                              obscureText: obscureText,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                suffix: GestureDetector(
                                  child: SizedBox(
                                    height: 22,
                                    child: Text(
                                      'view',
                                      style: TextStyle(fontFamily: 'medium', color: Color(0xffB6B6B6)),
                                    ),
                                  ),
                                  onTap: () {
                                    toggle();
                                  },
                                ),
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                                hintText: "password",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Regular', color: Color(0xffB6B6B6)),
                              ),
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff9F9F9F)),
                              textAlign: TextAlign.right,
                            ),
                            onPressed: () {
                              print('onpress');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => forgotPasswordScreen()),
                              );
                            },
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: KButtonDecoration,
                            child: TextButton(
                              onPressed: () async {
                                if (validate(email: email.text, password: password.text)) {
                                  login();
                                } else {
                                  Toasty.showtoast("Please Enter Your Email And Password");
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 18, fontFamily: 'medium', color: Colors.white),
                              ),
                            )),
                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            socialFBLogin();
                            print('Connect with Facebook');
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: kContainerDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15.0),
                                  child: Image(
                                    image: AssetImage('images/facebook.png'),
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 140,
                                  child: Center(
                                    child: Text(
                                      'Connect with Facebook',
                                      style: TextStyle(fontSize: 16, fontFamily: 'medium', color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            signInWithGoogle().then((result) {
                              if (result != null) {
                                loginByThirdParty(
                                  fgName: fgName,
                                  fgEmail: fgEmail,
                                  thirdPartyID: thirdPartyID,
                                  loginType: '2',
                                );
                              }
                            });
                            print('Connect with Google');
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 70),
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: kContainerDecoration,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15.0),
                                  child: Image(
                                    image: AssetImage('images/google.png'),
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 140,
                                  child: Center(
                                    child: Text(
                                      'Connect with Google',
                                      style: TextStyle(fontSize: 16, fontFamily: 'medium', color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: Platform.isIOS ? true : false,
                          child: GestureDetector(
                            onTap: () {
                              appleSignIn().then((credential) => {
                                    loginByThirdParty(loginType: '3', thirdPartyID: credential.userIdentifier, profilePic: 'profilePic', fgEmail: credential.email == null ? credential.userIdentifier.substring(0, 8) + '@gmail.com' : credential.email, fgName: credential.givenName == null ? 'user@' + credential.userIdentifier.substring(0, 4) : credential.givenName),
                                    print('APPLE_CREDENTIALS: $credential'),
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 70),
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: kContainerDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: Image(
                                      image: AssetImage('images/applelogo.png'),
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 140,
                                    child: Center(
                                      child: Text(
                                        'Connect with Apple',
                                        style: TextStyle(fontSize: 16, fontFamily: 'medium', color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff2F2F2F)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        page: SignUpScreen(),
                                      ));
                                },
                                child: Text(' Sign up', style: TextStyle(fontSize: 14, fontFamily: 'bold', color: Colors.black)),
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
          ),
        ),
      ),
    );
  }

  Widget slideTransition(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return HomeScreen();
    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeInCubic))),
        child: child,
      );
    }));
  }

  Widget fadeTransition(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return HomeScreen();
    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  Widget rotationTransition(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return HomeScreen();
    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return RotationTransition(
        turns: animation,
        child: SlideTransition(
          position: animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeInCubic))),
          child: child,
        ),
      );
    }));
  }

  Widget scaleTransition(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return Material(elevation: 16.0, child: HomeScreen());
    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0)).chain(CurveTween(curve: Curves.easeInCubic))),
        child: ScaleTransition(scale: animation, child: child),
      );
    }));
  }

  bool validate({String email, String password}) {
    if (email.isEmpty && password.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (email.isEmpty) {
      Toasty.showtoast('Please Enter Your Email Address');
      return false;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toasty.showtoast('Please Enter Valid Email Address');
      return false;
    } else if (password.isEmpty) {
      Toasty.showtoast('Please Enter Your Password');
      return false;
    } else if (password.length < 8) {
      Toasty.showtoast('Password Must Contains 8 Characters');
      return false;
    } else {
      return true;
    }
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.bounceInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
