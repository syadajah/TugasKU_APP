import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/screen/auth_register.dart';
import 'package:tugasku/screen/intro.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({super.key});

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(255, 125, 160, 196),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(top: 90, left: 23),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Intro()));
                    },
                    child: HeroIcon(HeroIcons.arrowLeft,
                        size: 20,
                        color: Color.fromARGB(225, 77, 77, 100),
                        style: HeroIconStyle.solid),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Intro()));
                    },
                    child: Text(
                      "Kembali",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color.fromARGB(225, 77, 77, 100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 105),
            Expanded(
                child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: EdgeInsets.only(top: 36, left: 23, right: 23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat datang",
                          style: TextStyle(
                              letterSpacing: -0.5,
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(225, 77, 77, 77)),
                        ),
                        Text(
                          "Silahkan masuk untuk menggunakan aplikasi!",
                          style: TextStyle(
                              letterSpacing: -0.2,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(225, 77, 77, 77)),
                        ),
                        SizedBox(height: 49),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(225, 242, 242, 242),
                            labelText: "Username",
                            labelStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Color.fromARGB(225, 128, 128, 128),
                            ),
                            prefixIcon: HeroIcon(HeroIcons.user,
                                size: 20,
                                color: Color.fromARGB(225, 128, 128, 128),
                                style: HeroIconStyle.solid),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                          ),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(225, 242, 242, 242),
                            labelText: "Kata Sandi",
                            labelStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Color.fromARGB(225, 128, 128, 128),
                            ),
                            prefixIcon: HeroIcon(HeroIcons.lockClosed,
                                size: 20,
                                color: Color.fromARGB(225, 128, 128, 128),
                                style: HeroIconStyle.solid),
                            suffixIcon: HeroIcon(HeroIcons.eyeSlash,
                                size: 20,
                                color: Color.fromARGB(225, 128, 128, 128),
                                style: HeroIconStyle.solid),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(225, 5, 38, 89),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                "Masuk",
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 12),
                              )),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Belum punya akun? ",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Color.fromARGB(225, 128, 128, 128),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AuthRegister()));
                              },
                              child: Text(
                                "Daftar",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Color.fromARGB(225, 5, 38, 89),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              thickness: 1,
                              color: Color.fromARGB(225, 179, 179, 179),
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Atau",
                                style: TextStyle(
                                  color: Color.fromARGB(225, 77, 77, 77),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 1,
                              color: Color.fromARGB(225, 179, 179, 179),
                            )),
                          ],
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(225, 255, 255, 255),
                                  foregroundColor:
                                      Color.fromARGB(255, 128, 128, 128),
                                ),
                                icon: SvgPicture.asset(
                                  "assets/icon/google.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                label: Text(
                                  "Masuk dengan Google",
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 12),
                                ))),
                      ],
                    )))
          ]),
        ),
      ),
    );
  }
}
