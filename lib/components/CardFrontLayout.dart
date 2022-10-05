import 'package:flutter/material.dart';

class CardFrontLayout {
  String bankName;
  String cardNumber;
  String cardExpiry;
  String cardHolderName;
  Widget cardTypeIcon;
  double cardWidth;
  double cardHeight;
  Color textColor;
  String cardType;

  CardFrontLayout({
    this.bankName = "",
    this.cardNumber = "",
    this.cardExpiry = "",
    this.cardHolderName = "",
    this.cardTypeIcon,
    this.cardWidth = 0,
    this.cardHeight = 0,
    this.textColor,
    this.cardType,
  });

  Widget layout1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset(
                    'images/atm-card.png',
                    height: 40,
                    width: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            cardNumber == null || cardNumber.isEmpty ? 'XXXX XXXX XXXX XXXX' : cardNumber,
                            style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontFamily: "bold", fontSize: 18),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cardHolderName == null || cardHolderName.isEmpty ? "Card Holder" : cardHolderName,
                                style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontFamily: "medium", fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Spacer(),
                              Text(
                                "Exp.Date",
                                style: TextStyle(color: textColor, fontFamily: "medium", fontSize: 15),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                cardExpiry == null || cardExpiry.isEmpty ? "MM/YY" : cardExpiry,
                                style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontFamily: "medium", fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(visible: false, child: cardTypeIcon)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
