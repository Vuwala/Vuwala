import 'package:flutter/material.dart';

class GreyHeading extends StatelessWidget {
  final String? text;
  final TextOverflow? overflow;
  final double? fontSize;
  final int? maxLines;
  GreyHeading({this.text, this.fontSize: 14, this.overflow, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return NewText(text: text!, color: Colors.grey.shade600, fontSize: fontSize!, overflow: overflow!, maxLines: maxLines!);
  }
}

class NewText extends StatelessWidget {
  NewText({
    this.text,
    this.fontFamily: 'Poppins-Regular',
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });
  final String? text;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(fontFamily: fontFamily, fontWeight: fontWeight, fontSize: fontSize, color: color),
      textAlign: textAlign,
    );
  }
}
