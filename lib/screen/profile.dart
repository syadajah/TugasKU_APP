import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/auth_login.dart';
import 'package:tugasku/screen/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //get auth service
  final authService = AuthService();
  Map<String, dynamic>? userData;
  String? name;
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    Map result = authService.getUserCurrentEmail();
    name = result['name'];
    email = result['email'];
  }

  void getUserData() async {
    final response = await authService.getCurrentUserData();
    setState(() {
      userData = response;
    });
  }

  // logout button function/pressed
  void logout() async {
    await authService.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => AuthLogin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile",
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
                          .start,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                userData != null ? userData!['full_name'] : '-',
                                style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                userData != null ? userData!['email'] : '-',
                                style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );

                                  if(result == true) {
                                    getUserData();
                                  }
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
                              onPressed: logout,
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
