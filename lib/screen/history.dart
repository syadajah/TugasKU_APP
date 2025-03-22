import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/Auth/auth_service.dart';
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
  Map<String, dynamic>? userData;
  
  @override
  void initState() {
    super.initState();
    getUserData();
  }
  
  Future<void> getUserData() async {
    final response = await authService.getCurrentUserData();
    setState(() {
      userData = response;
    });
    
    if (userData != null) {
      loadCompletedTasks();
    }
  }
  
  void loadCompletedTasks() async {
    setState(() {
      completedTasks = null; // Indicate loading
    });
    
    final tasks = await taskService.loadCompletedTasks(userData!['id']);
    setState(() {
      completedTasks = tasks;
    });
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
                  padding: EdgeInsets.all(16),
                  itemCount: completedTasks!.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks![index];
                    final completedAt = DateTime.parse(task['completed_at']);
                    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(completedAt);
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
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
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    task['categories'] != null 
                                        ? task['categories']['name'].toString()
                                        : "Tidak ada kategori",
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
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0x2027AE60),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xff27AE60),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: Color(0xff27AE60),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Selesai",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff27AE60),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              task['name'] ?? "Tidak ada judul",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff333333),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              task['description'] ?? "Tidak ada deskripsi",
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
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Diselesaikan pada: $formattedDate",
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
                    );
                  },
                ),
      ),
    );
  }
}