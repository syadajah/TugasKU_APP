import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String taskCount;

  const CategoryCard({super.key, required this.name, required this.taskCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        width: 130,
        height: 124,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Color(0xff021024),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xff021024),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              taskCount,
              style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: "Poppins",
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  "assets/icon/vectorcategory.svg",
                  width: 50,
                  height: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Center(
          child: CategoryCard(name: "Produktif", taskCount: "1 tugas"),
        ),
      ),
    ),
  );
}
