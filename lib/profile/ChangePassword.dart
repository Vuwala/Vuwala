import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Constants.dart';

class changePassword extends StatefulWidget {
  const changePassword({Key key}) : super(key: key);

  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  var _saving = false;
  @override
  void initState() {
    getToken111();
    super.initState();
  }

  var token;
  getToken111() async {
    token = await getToken();
  }

  var jsonData;
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  Dio dio = Dio();

  void chagePassword() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/change_password",
        data: {'current_password': currentPassword.text, 'new_password': newPassword.text},
        options: Options(
          headers: {"authorization": 'Bearer $token'},
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
          });
          Navigator.of(context).pop();
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
      setState(() {
        _saving = false;
      });
      print(e.response);
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Change Password',
            style: TextStyle(fontSize: 22, fontFamily: 'Regular', color: Color(0xff69a5a8)),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset(
                  'images/Icon ionic-ios-arrow-round-back.png',
                  height: 25.0,
                  width: 25.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: ModalProgressHUD(
          opacity: 0,
          inAsyncCall: _saving,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Password',
                            style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: currentPassword,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Current Password",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Regular', color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'New Password',
                            style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: newPassword,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "New Password",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Regular', color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Confirm Password',
                            style: TextStyle(fontSize: 14, fontFamily: 'medium', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: rePassword,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Regular', color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 30.0,
                  ),
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xff599a9a),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: 2.0,
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (validate(currentPass: currentPassword.text, newPass: newPassword.text, confPass: rePassword.text)) chagePassword();
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(fontSize: 18, fontFamily: 'medium', color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  bool validate({String currentPass, String newPass, String confPass}) {
    if (currentPass.isEmpty && newPass.isEmpty && confPass.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (currentPass.isEmpty) {
      Toasty.showtoast('Please Enter Your Current Password');
      return false;
    } else if (newPass.isEmpty) {
      Toasty.showtoast('Please Enter New Password');
      return false;
    } else if (confPass.isEmpty) {
      Toasty.showtoast('Please Re-Enter Your Password');
      return false;
    } else if (newPass.length < 8) {
      Toasty.showtoast('Password Must Contains 8 Characters');
      return false;
    } else if (newPass != confPass) {
      Toasty.showtoast('Password Must Be Same');
      return false;
    } else {
      return true;
    }
  }
}
