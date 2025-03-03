import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/screen/edit_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffffffff),),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Detail",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontSize: 22,
                color: Color(0xffffffff))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff052659),
        foregroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff052659),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/user-circle.svg",
                width: 120,
                height: 120,
              ),
              SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Color(0XFFFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Pastikan semua teks rata kiri
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "User",
                                style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                "@username",
                                style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  letterSpacing: -1,
                                ),
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(225, 5, 38, 89),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  "Edit Profil",
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Statistik",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"),
                                ),
                                Text(
                                  "Tuntas",
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
                              ],
                            ),
                            SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"),
                                ),
                                Text(
                                  "Belum Tuntas",
                                  style: TextStyle(fontFamily: "Poppins"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 125,
                        ),
                        Center(
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFFFFF),
                                foregroundColor: Color(0xff052659),
                                side: BorderSide(
                                    width: 1, color: Color(0xff052659)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                "LogOut",
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
