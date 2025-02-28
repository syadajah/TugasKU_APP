import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/screen/onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Onboarding())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color(0xffffffff),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 140,
                  height: 35,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: SvgPicture.asset(
                          "assets/icon/logo.svg",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(
                        "Tugas",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff021024),
                            letterSpacing: -1),
                      ),
                      Text(
                        "KU",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff4d4d4d),
                            letterSpacing: -1),
                      )
                    ],
                  )),
              Text(
                "Solusi kini mencatat tugas",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff4d4d4d),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
