import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/screen/homepage.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                    (route) => false);
              },
              icon: HeroIcon(HeroIcons.arrowLeft, style: HeroIconStyle.solid),
            ),
            SizedBox(width: 75),

            Text(
              "Riwayat",
              style: TextStyle(
                color: Color(0xff4D4D4D),
                fontSize: 20,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.10),
            child: Container(
              color: Color(0xffF7F7F7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
