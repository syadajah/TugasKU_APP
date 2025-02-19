import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/screen/auth_login.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({super.key});

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color.fromARGB(255, 125, 160, 196),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 90, left: 23),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthLogin()));
                            },
                            child: HeroIcon(HeroIcons.arrowLeft,
                                size: 20,
                                color: Color.fromARGB(225, 77, 77, 100),
                                style: HeroIconStyle.solid),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthLogin()));
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
                                "Silahkan daftar untuk menggunakan aplikasi!",
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
                                  labelText: "Name",
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
                                      backgroundColor:
                                          Color.fromARGB(225, 5, 38, 89),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      "Daftar",
                                      style: TextStyle(
                                          fontFamily: "Poppins", fontSize: 12),
                                    )),
                              ),
                              SizedBox(height: 25),
                            ]),
                      ),
                    ),
                  ],
                ))));
  }
}
