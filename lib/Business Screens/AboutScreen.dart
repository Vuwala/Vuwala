import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:vuwala/Constants.dart';

class AboutScreen extends StatefulWidget {
  final information;
  final phoneNo;
  final webName;
  AboutScreen({this.information, this.phoneNo, this.webName});
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _launched;
  String _phone = '';

  Future<void> _makePhoneCall(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(top: 5, right: 15, left: 15),
        child: Column(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(shape: BoxShape.rectangle, color: Color(0xffe9e9e9), borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Information', style: KAboutStyle),
                    ReadMoreText(widget.information ?? "", trimLines: 2, style: TextStyle(fontFamily: 'regular', fontSize: 12), colorClickableText: Colors.black, trimMode: TrimMode.Line, trimCollapsedText: 'Read more', trimExpandedText: 'Read less', moreStyle: KreadMoreStyle, lessStyle: KreadMoreStyle),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xffe9e9e9),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: KAboutStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _launched = _makePhoneCall(
                          'tel:${widget.phoneNo.toString()}',
                        );
                      }),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/phone-call.png',
                            height: 20,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            widget.phoneNo ?? '',
                            style: KTabBarStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            'images/globe.png',
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          widget.webName == 'null' ? 'No website' : widget.webName,
                          style: KTabBarStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xffe9e9e9),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Opending time',
                      style: KAboutStyle,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Monday - Friday',
                          style: TextStyle(fontFamily: 'regular'),
                        ),
                        Spacer(),
                        Icon(
                          Icons.brightness_1,
                          size: 8,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '8:30 - 12:30 PM',
                          style: KTabBarStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Icon(
                          Icons.brightness_1,
                          size: 8,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          '1:30 - 7:30 PM',
                          style: KTabBarStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          'Saturday',
                          style: TextStyle(fontFamily: 'regular'),
                        ),
                        Spacer(),
                        Icon(
                          Icons.brightness_1,
                          size: 8,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          '8:30 - 12:30 PM',
                          style: KTabBarStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
