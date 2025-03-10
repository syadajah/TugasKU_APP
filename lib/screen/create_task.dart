import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateTask extends StatelessWidget {
  const CreateTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 33,
            ),
            Text(
              "Tambah Tugas",
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 645,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(225, 242, 242, 242),
                      hintText: "Kategori",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(
                            13.0), // Menghindari ikon terlalu besar
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: SvgPicture.asset(
                            "assets/icon/collection.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff808080),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(
                            10.0), // Menghindari ikon terlalu besar
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            "assets/icon/arrow-down.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(225, 242, 242, 242),
                      hintText: "Nama project",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff808080),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff2f2f2),
                    hintText: "Deskripsi",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Color(0xff808080),
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffB3B3B3), width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  ),
                  maxLines: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(225, 242, 242, 242),
                      hintText: "Deadline",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(
                            13.0), // Menghindari ikon terlalu besar
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: SvgPicture.asset(
                            "assets/icon/calendar.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff808080),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(
                            10.0), // Menghindari ikon terlalu besar
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            "assets/icon/arrow-down.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 155,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(225, 5, 38, 89),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Tambah",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
