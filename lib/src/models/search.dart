import 'package:flutter/material.dart';

class SearchLoc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(hintColor: Colors.transparent),
      child: Container(
        height: 42,
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
              color: Color(0xFF757575),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF757575),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            fillColor: Color(0xFFEEEEEE),
            filled: true,
          ),
        ),
      ),
    );
  }
}
