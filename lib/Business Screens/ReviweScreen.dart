import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:vuwala/Business%20Screens/SalonDetailsScreen.dart';
import '../CachedImageContainer.dart';

class ReviewScreen extends StatefulWidget {
  final Servicelist;

  const ReviewScreen({this.Servicelist});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    print(widget.Servicelist);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: Service1.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ReviewTabTile(
            index: index,
            name: '${Service1[index]['first_name'] ?? ''} ${Service1[index]['last_name'] ?? ''}',
            date: Service1[index]['r_created_at'] ?? '',
            description: Service1[index]['rating_text'] ?? '',
          );
        },
      ),
    );
  }
}

class ReviewTabTile extends StatelessWidget {
  final name, date, description;
  final int index;
  const ReviewTabTile({this.name, this.date, this.description, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 15, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 240,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Service1[index]['profile_pic'].toString() == null || Service1[index]['profile_pic'].toString() == "null" || Service1[index]['profile_pic'].toString() == ""
                    ? Image.asset(
                        'images/Group 62509.png',
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                    : CachedImageContainer(
                        image: '$baseurl/${Service1[index]['profile_pic'].toString() ?? ' '}',
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        topCorner: 6,
                        bottomCorner: 6,
                        fit: BoxFit.cover,
                        placeholder: 'images/Group 62509.png',
                      ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 5),
                      child: Service1[index]['profile_pic'].toString() == null || Service1[index]['profile_pic'].toString() == "null" || Service1[index]['profile_pic'].toString() == ""
                          ? Image.asset(
                              'images/Group 62509.png',
                              height: 55,
                              width: 55,
                              fit: BoxFit.cover,
                            )
                          : CachedImageContainer(
                              image: '$baseurl/${Service1[index]['profile_pic'].toString() ?? ' '}',
                              width: 55,
                              height: 55,
                              topCorner: 6,
                              bottomCorner: 6,
                              fit: BoxFit.cover,
                              placeholder: 'images/Group 62509.png',
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width - 105,
                                    child: Row(
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(fontSize: 15, fontFamily: 'medium', color: Color(0xff393938)),
                                        ),
                                        Spacer(),
                                        SmoothStarRating(
                                          rating: double.parse(Service1[index]['rating_star'].toString()),
                                          isReadOnly: true,
                                          allowHalfRating: false,
                                          size: 20,
                                          color: Colors.orange,
                                          borderColor: Colors.grey,
                                          filledIconData: Icons.star,
                                          defaultIconData: Icons.star_border,
                                          starCount: 5,
                                          spacing: 2.0,
                                          onRated: (value) {
                                            print("rating value -> $value");
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
                                    width: MediaQuery.of(context).size.width - 110,
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
              ],
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
