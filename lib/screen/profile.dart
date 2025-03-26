import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/auth_login.dart';
import 'package:tugasku/screen/edit_profile.dart';
import 'package:tugasku/service/task_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final authService = AuthService();
  final taskService = TaskCreate();
  Map<String, dynamic>? userData;
  String? name;
  String? email;
  List<Map<String, dynamic>>? ongoingTasks;
  List<Map<String, dynamic>>? completedTasks;
  int ongoingTasksCount = 0;
  int completedTasksCount = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await getUserData();

    Map result = authService.getUserCurrentEmail();
    name = result['name'];
    email = result['email'];

    if (userData != null && userData!['id'] != null) {
      await getTasksData();
      calculateStatistics();
    } else {
      setState(() {
        _errorMessage = 'Gagal memuat data pengguna. Silakan coba lagi!';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getUserData() async {
    try {
      final response = await authService.getCurrentUserData();
      debugPrint('User data: $response');
      if (mounted) {
        setState(() {
          userData = response;
        });
      }
    } catch (e) {
      debugPrint('Error getting user data: $e');
      setState(() {
        _errorMessage = 'Error memuat data pengguna: $e';
      });
    }
  }

  Future<void> getTasksData() async {
    try {
      if (userData == null || userData!['id'] == null) {
        debugPrint('Error: userData atau userData["id"] null');
        setState(() {
          _errorMessage = 'Data pengguna tidak lengkap.';
        });
        return;
      }

      String userId = userData!['id'].toString();
      debugPrint('Mengambil tugas untuk userId: $userId');

      final List<Map<String, dynamic>> ongoing =
          await taskService.loadAssignments(userId);
      debugPrint('Tugas sedang dikerjakan: $ongoing');

      final List<Map<String, dynamic>> completed =
          await taskService.loadCompletedTasks(userId);
      debugPrint('Tugas selesai: $completed');

      if (mounted) {
        setState(() {
          ongoingTasks = ongoing;
          completedTasks = completed;
        });
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      if (mounted) {
        setState(() {
          ongoingTasks = [];
          completedTasks = [];
          _errorMessage = 'Gagal memuat data tugas: $e';
        });
      }
    }
  }

  void calculateStatistics() {
    if (mounted) {
      setState(() {
        ongoingTasksCount = ongoingTasks?.length ?? 0;
        completedTasksCount = completedTasks?.length ?? 0;
        debugPrint(
            'Statistik dihitung - Belum tuntas: $ongoingTasksCount, Tuntas : $completedTasksCount');
      });
    }
  }

  void logout() async {
    await authService.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => AuthLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double completionPercentage =
        (ongoingTasksCount + completedTasksCount) > 0
            ? completedTasksCount / (ongoingTasksCount + completedTasksCount)
            : 0.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
          ),
          onPressed: () async {
            Navigator.pop(context, true);
          },
        ),
        title: const Text(
          "Profil",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            fontSize: 22,
            color: Color(0xffffffff),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff052659),
        foregroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xff052659),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icon/user-circle.svg",
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color(0XFFFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                userData != null ? userData!['full_name'] : '-',
                                style: const TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                userData != null ? userData!['email'] : '-',
                                style: const TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {
                                      _isLoading = true;
                                      _errorMessage = null;
                                    });
                                    await getUserData();
                                    await getTasksData();
                                    calculateStatistics();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(225, 5, 38, 89),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  "Edit Profil",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Statistik",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _errorMessage != null
                                ? Center(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : (ongoingTasksCount + completedTasksCount) == 0
                                    ? const Center(
                                        child: Text(
                                          "Belum ada tugas.",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                            color: Color(0xff4d4d4d),
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    completedTasksCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Tuntas",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins"),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 40),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    ongoingTasksCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Belum Tuntas",
                                                    style: TextStyle(
                                                        fontFamily: "Poppins"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          LinearProgressIndicator(
                                            value: completionPercentage,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Color(0xff052659)),
                                            minHeight: 8,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Persentase Tuntas: ${(completionPercentage * 100).toStringAsFixed(1)}%",
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              color: Color(0xff4d4d4d),
                                            ),
                                          ),
                                        ],
                                      ),
                        const SizedBox(height: 85),
                        Center(
                          child: SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF),
                                foregroundColor: const Color(0xff052659),
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xff052659),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                "LogOut",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
