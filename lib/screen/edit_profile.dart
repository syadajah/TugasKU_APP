import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/Auth/auth_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //get auth servce session
  final authService = AuthService();

  final _namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff4D4D4D)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Edit Profile",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontSize: 22,
                color: Color(0xff4d4d4d))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xffF7F7F7),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xfff7f7f7),
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 23, right: 23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icon/Profile_edit.svg",
                  width: 120,
                  height: 120,
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _namecontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(225, 242, 242, 242),
                    hintText: "Name",
                    labelStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Color.fromARGB(225, 128, 128, 128),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffb3b3b3), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  ),
                ),
                SizedBox(
                  height: 300,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await authService.updateDisplayName(_namecontroller.text);
                      if(context.mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff052659),
                      foregroundColor: Color(0xffffffff),
                      side: BorderSide(width: 1, color: Color(0xff052659)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Edit",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
