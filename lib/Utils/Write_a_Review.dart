import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../Constants.dart';
import 'Round_Corner_Image.dart';

class ReviewScreen extends StatefulWidget {
  final int value;
  final businessID;
  final serviceId;
  const ReviewScreen({
    Key key,
    this.value = 0,
    this.serviceId,
    this.businessID,
  })  : assert(value != null),
        super(key: key);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController addReview = new TextEditingController();
  // TextEditingController rating = new TextEditingController();

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  var rating = 0.0;
  @override
  void initState() {
    print("lsfuydb");
    print(widget.businessID);
    print(widget.serviceId);
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
  }

  var token;

  getToken00() async {
    token = await getToken();
    print('Profile Token');
    print(token);
  }

  var jsonData;
  var data;
  var ratingStar;
  Dio dio = Dio();

  void writeReview() async {
    setState(() {});
    try {
      var response = await dio.post(
        "http://165.232.128.116/vuwala/api/write_review",
        data: {
          'business_id': widget.businessID,
          'service_id': widget.serviceId,
          'rating_star': ratingStar,
          'rating_text': addReview.text,
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
          setState(() {});
          Navigator.pop(context);
          Toasty.showtoast(jsonData['message']);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: 440,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Write a Review',
                                  style: KWriteReviewStyle,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.close, size: 30, color: Color(0xff599a9a)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SmoothStarRating(
                        rating: rating,
                        isReadOnly: false,
                        size: 30,
                        color: Colors.orange,
                        filledIconData: Icons.star,
                        borderColor: Colors.grey,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: false,
                        spacing: 3.0,
                        onRated: (value) {
                          print("value");
                          print(value);
                          print(ratingStar);
                          setState(() {
                            ratingStar = value;
                          });
                          print(ratingStar);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            child: DottedBorder(
                              color: Color(0xff1a9390),
                              strokeWidth: 2,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              child: _image == null
                                  ? GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add, size: 17, color: Color(0xff599a9a)),
                                            SizedBox(height: 10),
                                            Text(
                                              'Add Image',
                                              style: KWriteReviewStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 200,
                                        child: RoundCornerImage(height: 200, width: MediaQuery.of(context).size.width, image: '', circular: 10, placeholder: '', fileImage: _image),
                                      ),
                                    ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Material(
                              color: Colors.white,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: addReview,
                                cursorColor: Colors.black26,
                                decoration: InputDecoration(
                                  fillColor: Color(0xffADADAD),
                                  hintText: 'Write Your Review',
                                  hintStyle: KHintStyle,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: kBoxDecoration,
                          child: TextButton(
                            onPressed: () async {
                              await writeReview();
                            },
                            child: Text(
                              'Submit',
                              style: KButtonStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
