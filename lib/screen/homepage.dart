import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/fa_solid.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 5),
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
            SizedBox(
              width: 135,
            ),
            IconButton(
                onPressed: () {},
                icon: HeroIcon(
                  HeroIcons.userCircle,
                  size: 35,
                  color: Color(0xff021024),
                  style: HeroIconStyle.solid,
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xfff7f7f7),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 11, left: 23, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: 233,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: Color(0xffF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xff808080),
                                ),
                                hintText: "Search...",
                                hintStyle: TextStyle(
                                  color: Color(0xff808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            )),
                        Wrap(
                          spacing: -15,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: HeroIcon(
                                  HeroIcons.plus,
                                  size: 25,
                                  color: Color(0xff021024),
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Iconify(FaSolid.history,
                                    size: 20, color: Color(0xff021024))),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Kategori",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff4d4d4d),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Tugas yang sedang dikerjakan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff4d4d4d),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
