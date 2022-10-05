import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'Constants.dart';

class FilterScreen extends StatefulWidget {
  final cID;
  final List sName;

  const FilterScreen({Key key, this.cID, this.sName}) : super(key: key);
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

int sliderValue = 0;
int _sliderValue = 0;
int index = 0;

class _FilterScreenState extends State<FilterScreen> {
  List filter = [];
  var serviceName;
  @override
  void initState() {
    get();
    super.initState();
    serviceName = widget.sName[index]['service_name'];
  }

  get() async {
    await getToken00();
    await categoryService();
  }

  var token;
  getToken00() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  var distanceEnd;
  var maxPrice;

  Dio dio = Dio();

  void filterScreen() async {
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/filter_api",
        data: {
          'category_id': widget.cID,
          'distance_end': sliderValue,
          'max_price': _sliderValue,
          'avg_rating': ratingStar,
          'service_name': categoryservice[index]['service_name'],
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
          Navigator.of(context).pop();
          setState(() {});
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

  List categoryservice = [];
  void categoryService() async {
    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_category_service",
        data: {'category_id': widget.cID},
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
            categoryservice = jsonData['data']['services'];
          });
        }
        if (jsonData['status'] == 0) {
          _saving = false;
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
  var rating = 0.0;
  var ratingStar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Filters',
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
        inAsyncCall: _saving,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ListView(
                      children: <Widget>[
                        Text(
                          'Services',
                          style: TextStyle(color: Color(0xff000000), fontFamily: 'regular', fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: [
                                  GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: categoryservice.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: (3.3),
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: MyChips(categoryservice[index]['service_name'], index),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Rating',
                          style: TextStyle(color: Color(0xff000000), fontFamily: 'regular', fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SmoothStarRating(
                              rating: rating,
                              isReadOnly: false,
                              size: 30,
                              color: Colors.orange,
                              filledIconData: Icons.emoji_emotions_outlined,
                              borderColor: Colors.grey,
                              defaultIconData: Icons.emoji_emotions_rounded,
                              starCount: 5,
                              allowHalfRating: false,
                              spacing: 3.0,
                              onRated: (value) {
                                setState(() {
                                  ratingStar = value;
                                });
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('${ratingStar == null ? "0.00" : ratingStar.toString()} star' ?? '0.0'),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Distance',
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'regular',
                            fontSize: 20,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$sliderValue KM',
                            style: TextStyle(
                              color: Color(0xffB1B1B1),
                              fontFamily: 'regular',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          child: SliderTheme(
                            data: SliderThemeData(
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                            ),
                            child: Slider(
                              activeColor: Color(0xff149A9B),
                              value: sliderValue.toDouble(),
                              min: 0,
                              max: 100,
                              label: '$sliderValue',
                              onChanged: (double value) {
                                setState(() {
                                  sliderValue = value.round();
                                  // sliderValue.toInt();
                                  print(sliderValue);
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'regular',
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$$_sliderValue',
                              style: TextStyle(
                                color: Color(0xffB1B1B1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'regular',
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '\$100',
                              style: TextStyle(
                                color: Color(0xffB1B1B1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'regular',
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: SliderTheme(
                            data: SliderThemeData(
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                            ),
                            child: Slider(
                              activeColor: Color(0xff149A9B),
                              value: _sliderValue.toDouble(),
                              min: 0,
                              max: 100,
                              label: '$_sliderValue',
                              onChanged: (double val) {
                                print(val);
                                setState(() {
                                  _sliderValue = val.round();
                                  print(_sliderValue);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: kBoxDecoration,
                  child: TextButton(
                    onPressed: () {
                      filterScreen();
                    },
                    child: Text(
                      'Done',
                      style: KButtonStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int selectedIndex = 1;
  Container MyChips(String text, int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          height: 30.0,
          width: MediaQuery.of(context).size.width * 0.2777,
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: index == selectedIndex ? Color(0xff1a9390) : Colors.white, borderRadius: BorderRadius.circular(20.0), border: Border.all(color: index == selectedIndex ? Colors.white : Colors.grey, width: 1)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: index == selectedIndex ? Colors.white : Colors.grey,
                // height: 0.9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
