import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Constants.dart';
import 'BookingDetailsScreen.dart';

class BookAppointmentScreen extends StatefulWidget {
  final int b1ID;
  final int sID;

  final uId;
  final img;
  final title;
  final about;
  final rating;
  final ratingCount;
  final time;
  final price;

  const BookAppointmentScreen({Key key, this.b1ID, this.sID, this.img, this.title, this.about, this.rating, this.ratingCount, this.time, this.price, this.uId}) : super(key: key);

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String setDate;
  var selectedDate = DateTime.now();
  TextEditingController selectYourDate = TextEditingController();

  @override
  void initState() {
    getToken0();
    print(DateTime.now());
    super.initState();
  }

  selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2500),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kPrimaryColor,
            accentColor: kPrimaryColor,
            colorScheme: ColorScheme.light(primary: kPrimaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      print(selectedDate);
      selectYourDate.text = DateFormat("dd MMMM, yyyy").format(selectedDate);
      setState(() {});
    }
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
          height: 55.0,
          width: MediaQuery.of(context).size.width * 0.2777,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: index == selectedIndex ? Color(0xff1a9390) : Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Color(0xff1a9390), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 1.0,
              ),
            ],
          ),
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

  var token;
  getToken0() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  List images = [];
  var rating;

  Dio dio = Dio();
  var businessId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Book Appointment',
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
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select your date',
                    style: KBookAppointmentStyle,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  onTap: () {
                    selectDate(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  controller: selectYourDate,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Select date ',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: kOutlineInputBorder,
                    enabledBorder: kOutlineInputBorder,
                    errorBorder: kOutlineInputBorder,
                    focusedErrorBorder: kOutlineInputBorder,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'images/calendar (1).png',
                        height: 20,
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.grey[400], blurRadius: 2),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Available Slot',
                    style: KBookAppointmentStyle,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      MyChips('8:30 AM', 1),
                      MyChips('9:30 AM', 2),
                      MyChips('10:30 AM', 3),
                      MyChips('11:30 AM', 4),
                      MyChips('12:30 PM', 5),
                      MyChips('13:30 PM', 6),
                      MyChips('14:30 PM', 7),
                      MyChips('15:30 PM', 8),
                      MyChips('16:30 PM', 9),
                      MyChips('17:30 PM', 10),
                      MyChips('18:30 PM', 11),
                      MyChips('19:30 PM', 12),
                      MyChips('20:30 PM', 13),
                      MyChips('21:30 PM', 14),
                      MyChips('22:30 PM', 15),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: kBoxDecoration,
                child: TextButton(
                  onPressed: () {
                    if (selectYourDate.text.toString().isNotEmpty) {
                      // addBooking();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(
                                b1ID: widget.b1ID,
                                sID: widget.sID,
                                uId: widget.uId,
                                price: widget.price,
                                sDate: selectedDate,
                              )));
                    } else {
                      Toasty.showtoast('Select Date');
                    }
                  },
                  child: Text(
                    'Book Now',
                    style: KButtonStyle,
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
