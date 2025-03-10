import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/create_task.dart';
import 'package:tugasku/screen/history.dart';
import 'package:tugasku/screen/profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  //get auth service
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {

    final currentEmail = authService.getUserCurrentEmail();


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: const Color(0xfff7f7f7),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 20, top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          },
                          icon: const HeroIcon(
                            HeroIcons.userCircle,
                            size: 35,
                            color: Color(0xff021024),
                            style: HeroIconStyle.solid,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Selamat datang!",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4D4D4D),
                              ),
                            ),
                            Text(
                              "Halo, $currentEmail",
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff4D4D4D),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 38,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => History()),
                              );
                            },
                            label: const Text(
                              "Riwayat",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff4D4D4D),
                              ),
                            ),
                            icon: const Icon(Icons.history, size: 18),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFFFFF),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: const Color(0xfff7f7f7),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff808080),
                                ),
                                hintText: "Search...",
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Kategori",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4d4d4d),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Tugas yang sedang dikerjakan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4d4d4d),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTask()),
          );
        },
        icon: const HeroIcon(
          HeroIcons.plus,
          size: 20,
          color: Color(0xffffffff),
          style: HeroIconStyle.solid,
        ),
        label: const Text(
          "Tambah Tugas",
          style: TextStyle(
              fontSize: 12, color: Color(0xffffffff), fontFamily: "Poppins"),
        ),
        backgroundColor: Color(0xff052659), // Warna FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
