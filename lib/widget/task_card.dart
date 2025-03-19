import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/screen/detail_tugas.dart';
import 'package:tugasku/service/task_service.dart';

class TaskCard extends StatelessWidget {
  final String category;
  final String name;
  final String description;
  final String deadline;

  final TaskCreate _taskService = TaskCreate();

  TaskCard({
    super.key,
    required this.category,
    required this.name,
    required this.description,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    // Parse deadline dari string ke DateTime
    DateTime deadlineDate = DateTime.parse(deadline);

    // Hitung sisa waktu
    String remainingTime = _taskService.formatDuration(deadlineDate);

    // Tentukan warna berdasarkan sisa waktu
    Color timeColor = Color(0xff052659);
    if (deadlineDate.difference(DateTime.now()).inDays < 2) {
      timeColor = Color(0xff991B1B);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailTugas(
                      name: name,
                      category: category,
                      description: description,
                      deadline: deadline,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4D4D4D),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xff052659),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Icondeadline.svg",
                          width: 16,
                          height: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          remainingTime, // Tampilkan sisa waktu
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: timeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  color: Color(0xff333333),
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    color: Color(0xff4D4D4D),
                    fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
