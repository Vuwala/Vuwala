import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CostumeTextFiled extends StatelessWidget {
  final String text;
  final String hintText;
  final bool isShow;
  final Function(String) onChanged;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final Function() onTap;
  final Function Validate;
  var icon;
  var suffix;
  final TextInputType input;
  var validator;

  CostumeTextFiled({
    this.text,
    this.isShow,
    this.icon,
    this.suffix,
    this.input,
    this.hintText,
    this.onChanged,
    this.controller,
    this.inputFormatters,
    this.onTap,
    this.Validate,
    this.validator,
  });
  bool color = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.grey, fontFamily: "Medium", fontSize: 13),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)]),
          child: TextFormField(
            validator: validator,
            onTap: onTap,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            keyboardType: input,
            obscureText: isShow,
            obscuringCharacter: '*',
            style: TextStyle(color: Colors.grey),
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                helperStyle: TextStyle(color: Colors.grey, fontFamily: "Regular"),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                suffixIcon: icon,
                suffix: suffix,
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(8)))),
          ),
        ),
      ],
    );
  }
}
