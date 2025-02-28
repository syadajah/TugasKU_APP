import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Intro1 extends StatelessWidget {
  const Intro1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 88),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tugas",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Poppins",
                  color: Color(0xff021024),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "KU",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Poppins",
                  color: Color(0xff4D4D4D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 110),
          SvgPicture.asset(
            "assets/icon/onboard1.svg",
            width: 250,
            height: 200,
          ),
          SizedBox(height: 70),
          Text(
            "Catat Tugas!",
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Poppins",
              color: Color(0xff4d4d4d),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Catatan tugas mu kini lebih praktis dan aman",
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Poppins",
              color: Color(0xff4d4d4d),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "tanpa perlu ribet dan juga lebih terstruktur",
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Poppins",
              color: Color(0xff4d4d4d),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
