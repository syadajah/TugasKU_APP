import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tugasku/intro_screen/intro1.dart';
import 'package:tugasku/intro_screen/intro2.dart';
import 'package:tugasku/intro_screen/intro3.dart';
import 'package:tugasku/screen/auth_login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Controller to keep track of witch we're on
  final PageController _controller = PageController();

  // Keep track of if we are on the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [Intro1(), Intro2(), Intro3()],
        ),

        // Dot indicator

        Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Skip button
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Poppins",
                        color: Color(0xff4d4d4d),
                        fontWeight: FontWeight.w500,
                      ),
                    )),

                //dot indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Color(
                      0xff052659,
                    ),
                    dotColor: Color(0xff4d4d4d),
                  ),
                ),

                //Next or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AuthLogin();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            color: Color(0xff4d4d4d),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Poppins",
                            color: Color(0xff4d4d4d),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
              ],
            ))
      ]),
    );
  }
}
