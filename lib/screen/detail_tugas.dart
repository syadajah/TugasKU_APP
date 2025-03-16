import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailTugas extends StatefulWidget {
    final String category;
  final String name;
  final String description;
  final String deadline;
  const DetailTugas({    super.key,
    required this.category,
    required this.name,
    required this.description,
    required this.deadline,});

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff4D4D4D),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Detail",
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
      body: Container(
        color: Color(0xffF7F7F7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    side: BorderSide(width: 1, color: Color(0xffE6E6E6)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    label: Text(
                      widget.category,
                      style: TextStyle(
                          color: Color(0xff4d4d4d),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0x15052659),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xff052659)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Icondeadline.svg",
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: 4),
                        Text(widget.deadline,
                            style: TextStyle(
                                color: Color(0xff052659),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(widget.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Color(0xff333333))),
              SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: Color(0xff4D4D4D)),
              ),
              SizedBox(height: 51),
              Text("Foto",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Color(0xff333333))),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.image, color: Colors.grey.shade600),
                    SizedBox(width: 8),
                    Text("Upload Image",
                        style: TextStyle(
                            color: Color(0xff808080),
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                            fontSize: 12)),
                    Spacer(),
                    Icon(Icons.upload, color: Colors.grey.shade600),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Edit",
                          style: TextStyle(
                              color: Color(0xff052659),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              fontSize: 12)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff052659),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Selesai",
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
