import 'package:flutter/material.dart';
import '../Constants.dart';
import '../HomeScreen/HomeScreen1.dart';

class AppointmentBookSuccessfully extends StatefulWidget {
  @override
  _AppointmentBookSuccessfullyState createState() => _AppointmentBookSuccessfullyState();
}

class _AppointmentBookSuccessfullyState extends State<AppointmentBookSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset('images/Group 624.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Your appointment booking is successfully.',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: KAPSStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Order Id: #919100',
                          textAlign: TextAlign.center,
                          style: KAPSStyle,
                        ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen1()));
                    },
                    child: Text(
                      'Done',
                      style: KButtonStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
