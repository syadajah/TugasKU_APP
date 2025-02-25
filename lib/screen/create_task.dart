import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/screen/homepage.dart';

class CreateTask extends StatelessWidget {
  const CreateTask({super.key});

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
              SizedBox(width: 45),
              HeroIcon(HeroIcons.bookOpen, size: 30, color: Color(0xff021024)),
              SizedBox(width: 4),
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
        ),
      
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              color: Color(0xfff7f7f7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(225, 242, 242, 242),
                      hintText: "Kategori",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 10,
                        color: Color(0xff808080),
                      ),
                      prefixIcon: HeroIcon(HeroIcons.clipboardDocument,
                          size: 20,
                          color: Color.fromARGB(225, 128, 128, 128),
                          style: HeroIconStyle.solid),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
