import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/detail_tugas_history.dart';
import 'package:tugasku/service/task_service.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final authService = AuthService();
  final taskService = TaskCreate();

  List<Map<String, dynamic>>? completedTasks;

  @override
  void initState() {
    super.initState();
    _loadHistoryTasks();
  }

  Future<void> _loadHistoryTasks() async {
    final userData = await authService.getCurrentUserData();
    if (userData != null && userData['id'] != null) {
      final userId = userData['id'] as String;
      final tasks = await taskService.loadHistoryTasks(userId);
      setState(() {
        completedTasks = tasks;
      });
    }
  }

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
        title: Text(
          "Riwayat",
          style: TextStyle(
            color: Color(0xff4D4D4D),
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xffF7F7F7),
        child: completedTasks == null
            ? Center(child: CircularProgressIndicator())
            : completedTasks!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Belum ada tugas yang diselesaikan",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    itemCount: completedTasks!.length,
                    itemBuilder: (context, index) {
                      final task = completedTasks![index];

                      final bool isCompleted = task['status'] == 'completed';
                      final bool isExpired = taskService.isTaskExpired(task);

                      final String formattedDate;
                      if (isCompleted && task['completed_at'] != null) {
                        final completedAt =
                            DateTime.parse(task['completed_at']);
                        formattedDate = DateFormat('dd MMM yyyy, HH:mm')
                            .format(completedAt);
                      } else if (isExpired) {
                        final deadline = DateTime.parse(task['deadline']);
                        formattedDate =
                            DateFormat('dd MMM yyyy, HH:mm').format(deadline);
                      } else {
                        formattedDate = DateFormat('dd MMM yyyy, HH:mm')
                            .format(DateTime.now());
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailTugasHistory(
                                category: task['categories']['name'],
                                name: task['name'],
                                description: task['description'],
                                deadline: task['deadline'],
                                taskId: task['id'],
                                imageUrl: task[
                                    'image'], // Add this line to pass the image URL
                                status: task['status'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Color(0xffe6e6e6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        task['categories']['name'],
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff4D4D4D),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? Color(0x2027AE60)
                                            : Color(0x20EB5757),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isCompleted
                                              ? Color(0xff15803D)
                                              : Color(0xffB91C1C),
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
                                              colorFilter: isCompleted
                                                  ? ColorFilter.mode(
                                                      Color(0xff15803D),
                                                      BlendMode.srcIn)
                                                  : ColorFilter.mode(
                                                      Color(0xffB91C1C),
                                                      BlendMode.srcIn)),
                                          SizedBox(width: 4),
                                          Text(
                                            isCompleted
                                                ? "Selesai"
                                                : "Tidak Selesai",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isCompleted
                                                  ? Color(0xff15803D)
                                                  : Color(0xffB91C1C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  task['name'],
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  task['description'],
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    color: Color(0xff4D4D4D),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icon/icondeadline.svg",
                                        colorFilter: isCompleted
                                            ? ColorFilter.mode(
                                                Color(0xffffffff),
                                                BlendMode.srcIn)
                                            : ColorFilter.mode(
                                                Color(0x00000000),
                                                BlendMode.srcIn)),
                                    SizedBox(width: 4),
                                    Text(
                                      isCompleted
                                          ? "Diselesaikan pada: $formattedDate"
                                          : "Tugas terlewat pada: $formattedDate",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
