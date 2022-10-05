import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:vuwala/Booking%20Screens/BookAppointment.dart';
import 'package:vuwala/Business%20Screens/SalonDetailsScreen.dart';
import '../CachedImageContainer.dart';
import '../Constants.dart';

class HairstyleListScreen extends StatefulWidget {
  final serviceId;
  final serviceName;
  final ServicePrice, avgRate, sumRate, bName, bAddress;
  const HairstyleListScreen({
    Key key,
    this.serviceId,
    this.serviceName,
    this.ServicePrice,
    this.avgRate,
    this.sumRate,
    this.bName,
    this.bAddress,
  }) : super(key: key);

  @override
  _HairstyleListScreenState createState() => _HairstyleListScreenState();
}

class _HairstyleListScreenState extends State<HairstyleListScreen> {
  int pageIndex = 0;

  List<String> imgList = [];
  var ImageCatagory;
  @override
  void initState() {
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
    await listService();
  }

  var token;

  getToken00() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  List images = [];
  var rating;
  var Data;
  Dio dio = Dio();
  var businessId;
  listService() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/get_service_details",
        data: {'service_id': widget.serviceId},
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
          print(jsonData);
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
            Data = jsonData['data'];
            images = jsonData['data']['service_image'];
            businessId = jsonData['data']['business_id'];
          });

          for (int i = 0; i < images.length; i++) {
            print(i);
            imgList.add(images[i]["service_image"]);
          }
          print(imgList);
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

  final StoryController controller = StoryController();
  var _saving = false;
  var BaseUrl = "http://159.223.181.226/vuwala";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'images/Icon ionic-ios-arrow-round-back.png',
            height: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.serviceName,
          style: TextStyle(fontSize: 17, fontFamily: 'medium', color: Color(0xff1a9390)),
        ),
      ),
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _saving,
        child: Column(
          children: [
            images.isEmpty
                ? Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  )
                : Container(
                    color: Colors.grey,
                    margin: EdgeInsets.only(top: 38),
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: StoryView(
                      controller: controller,
                      storyItems: [
                        for (int i = 0; i < imgList.length; i++)
                          StoryItem.inlineImage(url: 'http://159.223.181.226/vuwala/${imgList[i]}', imageFit: BoxFit.cover, controller: controller),
                      ],
                      progressPosition: ProgressPosition.bottom,
                      repeat: true,
                      inline: true,
                    ),
                  ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                widget.serviceName,
                                // widget.Service["service_name"],
                                style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 17.0,
                                  color: Color(0xff000000),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'images/star.png',
                                height: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${widget.avgRate}(${widget.sumRate})',
                                style: TextStyle(
                                  fontFamily: 'medium',
                                  fontSize: 13.0,
                                  color: Color(0xffADADAD),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Spacer(),
                              Text(
                                '\$${widget.ServicePrice}',
                                style: TextStyle(fontSize: 15, fontFamily: 'medium', color: Color(0xff272627), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          InkWell(
                            onTap: () {
                              print(businessId);
                              print("businessId");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SalonServicesScreen(
                                    bID: businessId,
                                  ),
                                ),
                              );
                            },
                            child: Ink(
                              color: Colors.black12,
                              child: Text(
                                widget.bName,
                                style: KSalonNameStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.bAddress,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'medium',
                              color: Color(0xff272627),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 15),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Review',
                  style: TextStyle(fontSize: 15, fontFamily: 'medium', color: Color(0xff69a5a8), fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: review.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return ReviewTile(
                    index: index,
                    name: '${review[index]['first_name'] ?? ''}${review[index]['last_name'] ?? ''}',
                    date: review[index]['r_created_at'] ?? '',
                    description: review[index]['rating_text'] ?? '',
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
                          b1ID: Data['business_id'],
                          sID: Data['service_id'],
                          uId: Data['user_id'],
                          price: Data['service_price'],
                        ),
                      ),
                    );
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
        ),
      ),
    );
  }
}

List review = [];
var baseurl = "http://165.232.128.116/vuwala";

class ReviewTile extends StatelessWidget {
  final name, date, description;
  final int index;
  // final double rating;
  const ReviewTile({
    this.name,
    this.date,
    this.index,
    this.description,
    // this.rating,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    review[index]['profile_pic'].toString() == null || review[index]['profile_pic'].toString() == "null" || review[index]['profile_pic'].toString() == ""
                        ? Image.asset(
                            'images/Group 62509.png',
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : CachedImageContainer(
                            image: '$baseurl/${review[index]['profile_pic'].toString() ?? ' '}',
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            topCorner: 6,
                            bottomCorner: 6,
                            fit: BoxFit.cover,
                            placeholder: 'images/Group 62509.png',
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5, top: 10.0),
                          child:
                              review[index]['profile_pic'].toString() == null || review[index]['profile_pic'].toString() == "null" || review[index]['profile_pic'].toString() == ""
                                  ? Image.asset(
                                      'images/Group 62509.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedImageContainer(
                                      image: '$baseurl/${review[index]['profile_pic'].toString() ?? ' fkdlb'}',
                                      width: 50,
                                      height: 50,
                                      topCorner: 6,
                                      bottomCorner: 6,
                                      fit: BoxFit.cover,
                                      placeholder: 'images/Group 62509.png',
                                    ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Row(
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(fontSize: 15, fontFamily: 'medium', color: Color(0xff393938)),
                                        ),
                                        Spacer(),
                                        SmoothStarRating(
                                          rating: double.parse(review[index]['rating_star'].toString()),
                                          isReadOnly: true,
                                          size: 20,
                                          color: Colors.orange,
                                          allowHalfRating: false,
                                          borderColor: Colors.grey,
                                          filledIconData: Icons.star,
                                          defaultIconData: Icons.star_border,
                                          starCount: 5,
                                          spacing: 2.0,
                                          onRated: (value) {
                                            print("rating value -> $value");
                                            // setState(() {
                                            //   ratingStar = value;
                                            // });
                                            // print("rating value dd -> ${value.truncate()}");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(fontSize: 12, fontFamily: 'regular', color: Color(0xff959594)),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 11, fontFamily: 'regular', color: Color(0xff959594)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}
