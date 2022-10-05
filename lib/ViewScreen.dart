import 'package:flutter/material.dart';
import 'CachedImageContainer.dart';
import 'Constants.dart';
import 'FilterScreen.dart';

class ViewScreen extends StatefulWidget {
  final categoryName;
  final List Service;
  final Category;
  ViewScreen({
    this.categoryName,
    this.Service,
    this.Category,
  });
  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  List category = [];
  List category1 = [];
  List category11 = [];
  @override
  void initState() {
    super.initState();
  }

  var baseurl = "http://159.223.181.226/vuwala";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.categoryName ?? '',
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FilterScreen(
                            cID: widget.Category,
                            sName: widget.Service,
                          )),
                );
              },
              child: Image(
                image: AssetImage('images/filter.png'),
                color: Color(0xff149A9B),
                height: 20,
                width: 20,
              ),
            ),
          ),
        ],
      ),
      body: widget.Service.length != 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              itemCount: widget.Service.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(top: 10.0),
                    height: 230.0,
                    width: 350.0,
                    child: Column(
                      children: [
                        widget.Service[index]["service_thumbnail"] == null || widget.Service[index]["service_thumbnail"] == "null" || widget.Service[index]["service_thumbnail"] == ""
                            ? Image.asset(
                                'images/Group 62509.png',
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              )
                            : CachedImageContainer(
                                image: '$baseurl/${widget.Service[index]["service_thumbnail"] ?? ' fkdlb'}',
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                topCorner: 10,
                                bottomCorner: 10,
                                fit: BoxFit.cover,
                                placeholder: 'images/Group 62509.png',
                              ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          widget.Service[index]["service_name"],
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 15.0,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        Icon(Icons.star, color: Color(0xffFEC007)),
                                        Text(
                                          '${widget.Service[index]["avg_rating"]}(${widget.Service[index]['sum_rating']})',
                                          style: TextStyle(
                                            fontFamily: 'regular',
                                            fontSize: 10.0,
                                            color: Color(0xffADADAD),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Spacer(),
                                        Text(
                                          '\$${widget.Service[index]["service_price"]}',
                                          style: TextStyle(fontSize: 17, fontFamily: 'Bold', color: Color(0xff272627)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      widget.Service[index]["business_name"] ?? '',
                                      style: TextStyle(fontSize: 10, fontFamily: 'regular', color: Color(0xff272627)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      widget.Service[index]["business_address"] ?? '',
                                      style: TextStyle(fontSize: 10, fontFamily: 'regular', color: Color(0xff272627)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text('No Data Found'),
            ),
    );
  }
}
