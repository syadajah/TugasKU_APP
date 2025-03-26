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
  final authService = AuthService();
  final taskService = TaskCreate();
  List<Map<String, dynamic>>? assignments;
  List<Map<String, dynamic>>? filteredAssignments;
  List<Map<String, dynamic>>? categories;
  Map<String, dynamic>? userData;
  String? name;
  String? email;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
    _searchController.addListener(_filterTasks);
  }

  Future<void> initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await getUserData();

      Map result = authService.getUserCurrentEmail();
      name = result['name'];
      email = result['email'];

      if (userData != null) {
        await getAssignmentsData();
        await getCategoriesData();
      }
    } catch (e) {
      debugPrint('Error initializing data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> getUserData() async {
    try {
      final response = await authService.getCurrentUserData();
      if (mounted) {
        setState(() {
          userData = response;
        });
      }
    } catch (e) {
      debugPrint('Error getting user data: $e');
    }
  }

  Future<void> getCategoriesData() async {
    try {
      final categoriesData = await taskService.loadCategories();
      if (mounted) {
        setState(() {
          categories = categoriesData;
        });
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  List<Map<String, dynamic>> getUniqueCategories() {
    if (categories == null || assignments == null) return [];

    List<Map<String, dynamic>> uniqueCategories = [];

    for (var category in categories!) {
      List<Map<String, dynamic>> categoryTasks =
          assignments!.where((assignment) {
        bool isCategoryMatch = assignment['categories'] != null &&
            assignment['categories']['id'] == category['id'];

        DateTime deadline = DateTime.parse(assignment['deadline']);
        bool isActive = deadline.isAfter(DateTime.now()) &&
            assignment['status'] == TaskStatus.uncompleted.toShortString();

        return isCategoryMatch && isActive;
      }).toList();

      // Only add category if it has active tasks
      if (categoryTasks.isNotEmpty) {
        uniqueCategories.add({
          'id': category['id'],
          'name': category['name'],
          'task_count': '${categoryTasks.length} Tugas',
        });
      }
    }

    return uniqueCategories;
  }

  Future<void> getAssignmentsData() async {
    try {
      final data = await taskService.loadAssignments(userData!['id']);
      if (mounted) {
        setState(() {
          assignments = data;
          filteredAssignments = List.from(data);
        });
        _filterTasks(); // Tambahkan ini
      }
    } catch (e) {
      debugPrint('Error loading assignments: $e');
      if (mounted) {
        setState(() {
          assignments = [];
          filteredAssignments = [];
        });
      }
    }
  }

  Future<void> refreshData() async {
    if (mounted) {
      await initializeData();
      _filterTasks();
    }
  }

  void _filterTasks() {
    if (assignments == null) return;

    final query = _searchController.text.toLowerCase().trim();
    debugPrint("Filtering with query: $query");

    setState(() {
      if (query.isEmpty) {
        filteredAssignments = List.from(assignments!);
      } else {
        filteredAssignments = assignments!.where((task) {
          final taskName = task['name']?.toString().toLowerCase() ?? '';
          return taskName.contains(query);
        }).toList();
      }
      debugPrint("Filtered Tasks Count: ${filteredAssignments?.length}");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCategories = getUniqueCategories();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: refreshData,
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
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()),
                            );
                            if (result == true) {
                              refreshData();
                            }
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
                                controller: _searchController,
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
                            const SizedBox(height: 20),
                            _isLoading
                                ? SizedBox(
                                    height: 135,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : uniqueCategories.isNotEmpty
                                    ? SizedBox(
                                        height: 135,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            int categoryId =
                                                uniqueCategories[index]['id'];
                                            return CategoryCard(
                                              category: uniqueCategories[index]
                                                      ['name']
                                                  .toString(),
                                              taskCount: uniqueCategories[index]
                                                      ['task_count']
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
                                    : SizedBox(
                                        height: 135,
                                        child: Center(
                                          child: Text(
                                            "Belum ada kategori dengan tugas aktif",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              color: Color(0xff4d4d4d),
                                            ),
                                          ),
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
                            const SizedBox(height: 20),
                            _isLoading
                                ? Expanded(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : filteredAssignments != null ||
                                        filteredAssignments!.isNotEmpty
                                    ? Expanded(
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                          shrinkWrap: true,
                                          itemCount:
                                              filteredAssignments!.length,
                                          itemBuilder: (context, index) {
                                            return TaskCard(
                                              taskId:
                                                  filteredAssignments![index]
                                                          ['id']
                                                      .toString(),
                                              category: filteredAssignments![
                                                              index]
                                                          ['categories'] !=
                                                      null
                                                  ? filteredAssignments![index]
                                                          ['categories']['name']
                                                      .toString()
                                                  : "Tidak ada kategori",
                                              categoryId: filteredAssignments![
                                                              index]
                                                          ['categories'] !=
                                                      null
                                                  ? filteredAssignments![index]
                                                          ['categories']['id']
                                                      .toString()
                                                  : "",
                                              name: filteredAssignments![index]
                                                      ['name']
                                                  .toString(),
                                              description:
                                                  filteredAssignments![index]
                                                          ['description']
                                                      .toString(),
                                              deadline:
                                                  filteredAssignments![index]
                                                          ['deadline']
                                                      .toString(),
                                              onUpdate: refreshData,
                                            );
                                          },
                                        ),
                                      )
                                    : Expanded(
                                        child: Center(
                                          child: Text(
                                            "Belum ada tugas yang ditambahkan",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12,
                                              color: Color(0xff4d4d4d),
                                            ),
                                          ),
                                        ),
                                      ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTask()),
          );
          if (result == true) {
            refreshData();
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
            fontSize: 12,
            color: Color(0xffffffff),
            fontFamily: "Poppins",
          ),
        ),
        backgroundColor: Color(0xff052659),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
