import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value ',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: InputBorder.none,
);

const kTextDecoration = InputDecoration(
  hintText: 'Enter a value ',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xffffffff),
    ),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffffffff), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

final kOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.white),
  borderRadius: BorderRadius.circular(8),
);

final kBoxDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  color: Color(0xff1a9390),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[400],
      blurRadius: 2.0,
    ),
  ],
);

const kPrimaryColor = Color(0xff1a9390);

final kPrimary1Color = Color(0xFF077f7b);

const kGreyTitleSmall = TextStyle(
    color: Colors.grey,
    fontFamily: 'regular',
    fontWeight: FontWeight.bold,
    fontSize: 14);

const KAppbarStyle =
    TextStyle(fontSize: 19, fontFamily: 'medium', color: Color(0xff1a9390));

const KTabBarStyle =
    TextStyle(fontSize: 15, color: Color(0xff599a9a), fontFamily: 'medium');

const KAboutStyle =
    TextStyle(fontSize: 16, color: Color(0xff599a9a), fontFamily: 'medium');

const KSalonNameStyle =
    TextStyle(fontSize: 15, fontFamily: 'medium', color: Color(0xff272627));

const KButtonStyle =
    TextStyle(fontSize: 15, fontFamily: 'medium', color: Colors.white);

const KAPSStyle = TextStyle(fontSize: 17, fontFamily: 'medium');

const KBookAppointmentStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'medium',
    color: Color(0xff69a5a8),
    fontWeight: FontWeight.w600);

const KCardTextStyle = TextStyle(fontSize: 15, color: Color(0xFF7286A1));

const KOrderIdStyle = TextStyle(fontSize: 15, fontFamily: 'medium');

const KStarReviewStyle =
    TextStyle(fontFamily: 'medium', fontSize: 13.0, color: Color(0xffADADAD));

const KBookingStyle =
    TextStyle(fontSize: 15, fontFamily: 'bold', color: Color(0xff393938));

const KTextStyle =
    TextStyle(fontSize: 13, fontFamily: 'regular', color: Color(0xff393938));

const KreadMoreStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Color(0xff599a9a),
    fontFamily: 'regular');

const KWriteReviewStyle = TextStyle(
    fontSize: 16,
    color: Color(0xff599a9a),
    decoration: TextDecoration.none,
    fontFamily: 'regular');

const KHintStyle =
    TextStyle(color: Colors.grey, fontFamily: 'regular', fontSize: 13);

const kInputTextStyleBlack = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
    fontFamily: 'regular',
    decoration: TextDecoration.none);
Future setPrefData({String key, String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future getPrefData({String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key);
  return data;
}

Future clearPrefData({String key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = await prefs.remove(key);
  return data;
}

Future<void> keepLogedIn() async {
  SharedPreferences login = await SharedPreferences.getInstance();
  login?.setBool("isLoggedIn", true);
}

var UserToken;
final box = GetStorage();

getToken() async {
  final prefs = await SharedPreferences.getInstance();
  UserToken = await box.read('userToken');
  print(UserToken);
  print("Token");
  return UserToken;
}

var businnessId;
getBusinessId() async {
  SharedPreferences businessId1 = await SharedPreferences.getInstance();
  businnessId = businessId1.getString('business_id');
  return businnessId;
}

// var Customer_Id;
// getCustomerId() async {
//   SharedPreferences Customer_Id1 = await SharedPreferences.getInstance();
//   Customer_Id = Customer_Id1.getString('CustomerId');
//   print("Customer id is $Customer_Id");
//   return Customer_Id;
// }

var userId;
getUserId() async {
  SharedPreferences userId1 = await SharedPreferences.getInstance();
  userId = userId1.getString('user_id');
  return userId;
}

final kContainerDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey[400],
      blurRadius: 3.0,
    ),
  ],
);
const kAnimationDuration = Duration(milliseconds: 200);
final KButtonDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  color: Color(0xffD8B65C),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      // offset: Offset(2, 2),
      color: Colors.grey[400],
      blurRadius: 3.0,
    ),
  ],
);

final kDropdownDeco = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  filled: true,
  fillColor: Colors.white,
  focusedBorder: kOutlineInputBorder,
  enabledBorder: kOutlineInputBorder,
  errorBorder: kOutlineInputBorder,
  focusedErrorBorder: kOutlineInputBorder,
  // labelStyle: kTextFieldStyle,
);
final kButtonStyleWhitSmall = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
  fontFamily: 'regular',
  decoration: TextDecoration.none,
);

final kButtonStyleGreySmall = TextStyle(
  fontSize: 12.0,
  color: Colors.grey,
  fontFamily: 'regular',
  decoration: TextDecoration.none,
);
final kDarkGreenSmallest = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
  fontFamily: 'regular',
  decoration: TextDecoration.none,
);
final kTextTitle1 = TextStyle(
  fontSize: 19.0,
  color: Color(0xFF7286A1),
  fontFamily: 'PoppinsMedium',
  decoration: TextDecoration.none,
);

class Toasty {
  static showtoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.5),
    );
  }
}

Future socialMediaSignOut() async {
  try {
    await _googleSignIn.signOut();
  } catch (e) {
    print(e);
    // TODO
  }
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);
