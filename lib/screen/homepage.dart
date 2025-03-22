import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/create_task.dart';
import 'package:tugasku/screen/history.dart';
import 'package:tugasku/screen/profile.dart';
import 'package:tugasku/service/task_service.dart';
import 'package:tugasku/widget/category_card.dart';
import 'package:tugasku/widget/task_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //get auth service
  final authService = AuthService();

  List<Map<String, dynamic>>? assignments;
  Map<String, dynamic>? userData;
  String? name;
  String? email;

  //get task service
  final taskService = TaskCreate();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    Map result = authService.getUserCurrentEmail();
    name = result['name'];
    email = result['email'];

    getAssignments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserData() async {
    final response = await authService.getCurrentUserData();
    setState(() {
      userData = response;
    });
  }

List<Map<String, dynamic>> getUniqueCategories() {
  if (assignments == null) return [];
  
  // Buat map untuk menyimpan kategori unik dan menghitung jumlah tugas
  Map<int, Map<String, dynamic>> uniqueCategoriesMap = {};
  
  // Loop melalui assignments dan tambahkan kategori ke map
  for (var assignment in assignments!) {
    int categoryId = assignment['categories']['id'];
    String categoryName = assignment['categories']['name'];
    
    // Jika categoryId belum ada di map, tambahkan
    if (!uniqueCategoriesMap.containsKey(categoryId)) {
      uniqueCategoriesMap[categoryId] = {
        'id': categoryId,
        'name': categoryName,
        'task_count': "0", // Inisialisasi dengan 0
        'count': 0, // Counter internal
      };
    }
    
    // Tambahkan perhitungan untuk kategori ini
    uniqueCategoriesMap[categoryId]?['count'] = uniqueCategoriesMap[categoryId]?['count'] + 1;
    int count = uniqueCategoriesMap[categoryId]?['count'];
    uniqueCategoriesMap[categoryId]?['task_count'] = "$count Tugas";
  }
  
  // Konversi map ke list
  return uniqueCategoriesMap.values.toList();
}

  void getAssignments() async {
    setState(() {
      // Indicate loading state
      assignments = null;
    });

    await getUserData();
    taskService.loadAssignments(userData!['id']).then((data) {
      debugPrint('Data: $data');
      setState(() {
        assignments = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final uniqueCategories = getUniqueCategories();
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xfff7f7f7),
            child: Padding(
              padding: const EdgeInsets.only(left: 9, right: 13, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        },
                        icon: const HeroIcon(
                          HeroIcons.userCircle,
                          size: 35,
                          color: Color(0xff021024),
                          style: HeroIconStyle.solid,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Selamat datang!",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                          Text(
                            "Halo, ${userData != null ? userData!['full_name'] : '-'}",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4D4D4D),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History()),
                            );
                          },
                          label: Text(
                            "Riwayat",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff4D4D4D),
                            ),
                          ),
                          icon: const Icon(Icons.history, size: 18),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xfff7f7f7),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff808080),
                                ),
                                hintText: "Search...",
                                hintStyle: const TextStyle(
                                  color: Color(0xff808080),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Kategori dan jumlah tugas",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4d4d4d),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          uniqueCategories.isNotEmpty
                              ? SizedBox(
                                  height: 135,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      // Pastikan nilai categoryId dari assignments
                                      int categoryId = uniqueCategories[index]['id'];

                                      return CategoryCard(
                                        category: uniqueCategories[index]['name']
                                            .toString(),
                                        taskCount: uniqueCategories[index]['task_count']
                                            .toString(),
                                        categoryId: categoryId,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(width: 10),
                                    shrinkWrap: true,
                                    itemCount: uniqueCategories.length,
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                          const SizedBox(height: 40),
                          const Text(
                            "Tugas yang sedang dikerjakan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff4d4d4d),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          assignments != null
                              ? Expanded(
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 10,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: assignments!.length,
                                    itemBuilder: (context, index) {
                                      return TaskCard(
                                        category: assignments![index]
                                                ['categories']['name']
                                            .toString(),
                                        name: assignments![index]['name']
                                            .toString(),
                                        description: assignments![index]
                                                ['description']
                                            .toString(),
                                        deadline: assignments![index]
                                                ['deadline']
                                            .toString(),
                                      );
                                    },
                                  ),
                                )
                              : Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTask()),
          );
          if (result == true) {
            getAssignments(); // Refresh data setelah kembali dari CreateTask
          }
        },
        icon: const HeroIcon(
          HeroIcons.plus,
          size: 20,
          color: Color(0xffffffff),
          style: HeroIconStyle.solid,
        ),
        label: const Text(
          "Tambah Tugas",
          style: TextStyle(
              fontSize: 12, color: Color(0xffffffff), fontFamily: "Poppins"),
        ),
        backgroundColor: Color(0xff052659), // Warna FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}