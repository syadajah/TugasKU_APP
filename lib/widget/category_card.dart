import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/service/task_service.dart';

class CategoryCard extends StatefulWidget {
  final String category;
  final String taskCount;
  final int categoryId;
  const CategoryCard({
    super.key,
    required this.category,
    required this.taskCount,
    required this.categoryId,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final TaskCreate _taskService = TaskCreate();
  String taskCount = "0 Tugas"; // Default sebelum data dimuat
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi taskCount dari prop
    taskCount = widget.taskCount;

    // Jika taskCount kosong atau tidak berformat "X Tugas", muat dari DB
    if (taskCount.isEmpty || !taskCount.contains("Tugas")) {
      loadTaskCount();
    }
  }

  Future<void> loadTaskCount() async {
    // Hindari multiple calls
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final count = await _taskService.getTaskCountByCategory(widget.categoryId);

      if (mounted) {
        setState(() {
          taskCount = count;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
              widget.category,
              style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              // Gunakan state taskCount
              _isLoading ? "Memuat..." : taskCount,
              style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: "Poppins",
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
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