import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/service/task_service.dart';

class DetailTugas extends StatefulWidget {
  final String category;
  final String name;
  final String description;
  final String deadline;
  final String taskId;

  final TaskCreate _taskService = TaskCreate();

  DetailTugas({
    super.key,
    required this.category,
    required this.name,
    required this.description,
    required this.deadline,
    required this.taskId,
  });

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Parse deadline dari string ke DateTime
    DateTime deadlineDate = DateTime.parse(widget.deadline);

    // Hitung sisa waktu
    String remainingTime = widget._taskService.formatDuration(deadlineDate);

    // Tentukan warna berdasarkan sisa waktu
    Color timeColor = Color(0xff052659);
    Color bgTimeColor = Color(0x20052659);
    if (deadlineDate.difference(DateTime.now()).inDays < 2) {
      timeColor = Color(0xff991B1B);
      bgTimeColor = Color(0x20991B1B);
    }

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
                      color: bgTimeColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: timeColor),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Icondeadline.svg",
                          width: 16,
                          height: 16,
                          colorFilter:
                              ColorFilter.mode(timeColor, BlendMode.srcIn),
                        ),
                        SizedBox(width: 4),
                        Text(remainingTime,
                            style: TextStyle(
                                color: timeColor,
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
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              bool success = await widget._taskService
                                  .completeTask(int.parse(widget.taskId));
                              setState(() {
                                _isLoading = false;
                              });
                              if (success) {
                                // Return true to indicate success
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Gagal menyelesaikan tugas!")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Gagal menyelesaikan tugas!")));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Tugas selesai!")));
                                Navigator.pop(context, true);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff052659),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text("Selesai",
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
