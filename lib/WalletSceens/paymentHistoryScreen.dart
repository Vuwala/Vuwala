import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Payment History',
          style: TextStyle(
              fontSize: 22,
              fontFamily: 'PoppinsMedium',
              color: Color(0xff69a5a8)),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'images/icons/an_Icon ionic-ios-arrow-round-back.png',
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xff599a9a),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    height: 100.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'PoppinsRegular',
                              color: Colors.white),
                        ),
                        Text(
                          '\$2530.30',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'PoppinsRegular',
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All History',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'PoppinsRegular',
                              color: Color(0xff888888)),
                        ),
                        Text(
                          'Date',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'PoppinsRegular',
                              color: Color(0xff888888)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 15,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.white,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Image.asset(
                                                  'images/an_ex.jpg',
                                                  width: 45,
                                                  height: 45,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'KaileyAdams',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'PoppinsMedium',
                                                    color: Color(0xff626162),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'order id: ',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        color:
                                                            Color(0xff626162),
                                                      ),
                                                    ),
                                                    Text(
                                                      '£919100',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        color:
                                                            Color(0xff0d00ff),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\$540.00',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'PoppinsMedium',
                                              color: Color(0xff626162),
                                            ),
                                          ),
                                          Text(
                                            '17 sep,2020',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'PoppinsRegular',
                                              color: Color(0xff626162),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
