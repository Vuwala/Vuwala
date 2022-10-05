import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'CachedImageContainer.dart';
import 'Constants.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double latitude, longitude;
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;
  }

  GoogleMapController mapController;
  static const LatLng _center = const LatLng(21.170240, 72.831062);
  final Set<Marker> _marker = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  void _onMapCreated(GoogleMapController controller) {
    showPinsOnMap();
    mapController = controller;
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  bool userBadgeSelected = false;

  void showPinsOnMap() {
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: _lastMapPosition,
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            setState(() {
              this.userBadgeSelected = true;
            });
          }));
    });
  }

  List categoryMap = [];
  @override
  void initState() {
    getCurrentLocation();
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
    await Maplist();
  }

  var token;

  getToken00() async {
    token = await getToken();
    print('Profile Token');
    print(token);
  }

  var jsonData;
  var data;

  Dio dio = Dio();
  bool isMap = false;
  void Maplist() async {
    setState(() {
      isMap = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_service_on_map",
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
            categoryMap = jsonData['data'];
            isMap = false;
          });
          print('serviceAnkit');
          print(categoryMap);
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        isMap = false;
      });
      print(e.message);
      print(e.response);
    }
  }

  var baseurl = "http://159.223.181.226/vuwala";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: isMap,
        child: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  mapToolbarEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: _lastMapPosition, zoom: 11.0),
                  mapType: _currentMapType,
                  markers: _marker,
                  onCameraMove: _onCameraMove,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 260,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: categoryMap.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 250.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 10),
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
                                  width: 250.0,
                                  child: Column(
                                    children: [
                                      categoryMap[index]['service_thumbnail'] == null || categoryMap[index]['service_thumbnail'] == "null" || categoryMap[index]['service_thumbnail'] == ""
                                          ? Image.asset(
                                              'images/Group 62509.png',
                                              height: 150,
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedImageContainer(
                                              image: '$baseurl/${categoryMap[index]['service_thumbnail'] ?? ' fkdlb'}',
                                              width: MediaQuery.of(context).size.width,
                                              height: 150,
                                              topCorner: 10,
                                              bottomCorner: 0,
                                              fit: BoxFit.fitWidth,
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
                                                      Container(
                                                        // color: Colors.red,
                                                        width: 100,
                                                        child: Text(
                                                          categoryMap[index]['service_name'],
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins-Medium',
                                                            fontSize: 15.0,
                                                            color: Color(0xff000000),
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(Icons.star, color: Color(0xffFEC007)),
                                                      Text(
                                                        '${categoryMap[index]['avg_rating'] ?? ''}(${categoryMap[index]['sum_rating'] ?? ''})',
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins-Medium',
                                                          fontSize: 13.0,
                                                          color: Color(0xffADADAD),
                                                        ),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      Spacer(),
                                                      Text(
                                                        '\$${categoryMap[index]['service_price'] ?? ''}',
                                                        style: TextStyle(fontSize: 17, fontFamily: 'PoppinsBold', color: Color(0xff272627)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    categoryMap[index]['business_name'] ?? '',
                                                    style: TextStyle(fontSize: 10, fontFamily: 'Poppins-Medium', color: Color(0xff272627)),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    categoryMap[index]['business_address'] ?? '',
                                                    style: TextStyle(fontSize: 10, fontFamily: 'Poppins-Medium', color: Color(0xff272627)),
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
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController addressController = TextEditingController();
}
