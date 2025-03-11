import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/auth_login.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({super.key});

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  //get auth servce session
  final authService = AuthService();

  //textControllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //Sign up button function/pressed
  void signUp() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    //check if password and confirm password is the same
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password Doesn't Match!"),
        ),
      );
      return;
    }

    // attempt to sign up..
    try {
      await authService.signUpWithEmailPassword(email, password, "TugasKU");
      //pop this register page
      Navigator.pop(context);
    }

    //catch any error
    catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xff052659),
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
                          color: Color(0xffffffff),
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
                          color: Color(0xffffffff),
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(225, 242, 242, 242),
                            labelText: "E-Mail",
                            labelStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Color.fromARGB(225, 128, 128, 128),
                            ),
                            prefixIcon: SvgPicture.asset("assets/icon/Mail.svg",
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                    Color.fromARGB(225, 128, 128, 128),
                                    BlendMode.srcIn)),
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
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(225, 242, 242, 242),
                            labelText: "Password",
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
                        SizedBox(height: 15),
                        TextField(
                          obscureText: true,
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(225, 242, 242, 242),
                            labelText: "Confirm Password",
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
                              onPressed: signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(225, 5, 38, 89),
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
          ),
        ),
      ),
    );
  }
}
