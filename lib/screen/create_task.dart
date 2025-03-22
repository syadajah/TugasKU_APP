import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/service/task_service.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final authService = AuthService();
  final taskService = TaskCreate();

  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? userData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  int? selectedCategoryId;
  DateTime? selectedDeadline; // Tambahkan variabel untuk menyimpan tanggal deadline

  @override
  void initState() {
    getCategories();
    getUserData();
    super.initState();
  }

  void getUserData() async {
    final response = await authService.getCurrentUserData();
    setState(() {
      userData = response;
    });
  }

  void getCategories() async {
    taskService.loadCategories().then((data) {
      debugPrint('Data: $data');
      setState(() {
        categories = data;
      });
    });
  }

  Future<void> _handleSubmitted(String value) async {
    if (value.isNotEmpty) {
      final existingCategory = categories.firstWhere(
          (c) => c['name'].toString().toLowerCase() == value.toLowerCase(),
          orElse: () => {'id': null});

      if (existingCategory.isNotEmpty && existingCategory['id'] != null) {
        setState(() {
          selectedCategoryId = existingCategory['id'];
        });

        return;
      }

      Map<String, dynamic>? newCategory = await taskService.addNewCategory(
        value,
        categories,
      );

      if (newCategory != null) {
        setState(() {
          categories.add(newCategory);
          selectedCategoryId = newCategory['id'];
        });
      }
    }
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      // Tampilkan dialog untuk memilih waktu
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (timePicked != null) {
        // Gabungkan tanggal dan waktu
        final DateTime deadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );
        
        setState(() {
          selectedDeadline = deadline;
          // Format tanggal dan waktu untuk ditampilkan di TextField
          deadlineController.text = DateFormat('dd-MM-yyyy HH:mm').format(deadline);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 33,
            ),
            Text(
              "Tambah Tugas",
              style: TextStyle(
                color: Color(0xff4D4D4D),
                fontSize: 20,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 645,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return categories.map((c) => c['name'] as String).where(
                          (name) => name.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                        );
                  },
                  onSelected: (String value) {
                    final selectedCategory = categories.firstWhere(
                        (c) => c['name'] == value,
                        orElse: () => {'id': null});
                    setState(() {
                      selectedCategoryId = selectedCategory['id'];
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(225, 242, 242, 242),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff808080),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Pilih atau buat kategori',
                        labelStyle: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Color(0xff808080),
                          fontWeight: FontWeight.w500,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            _handleSubmitted(controller.text);
                            focusNode.unfocus();
                          },
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      ),
                      onSubmitted: (value) {
                        _handleSubmitted(controller.text);
                        focusNode.unfocus();
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(225, 242, 242, 242),
                      hintText: "Nama Tugas",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff808080),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xfff2f2f2),
                    hintText: "Deskripsi",
                    hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Color(0xff808080),
                      fontWeight: FontWeight.w500,
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffB3B3B3), width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  ),
                  maxLines: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextField(
                    onTap: _showDatePicker,
                    controller: deadlineController,
                    readOnly: true, // Tambahkan readOnly agar tidak bisa edit manual
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(225, 242, 242, 242),
                      hintText: "Deadline",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Color(0xff808080),
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(13.0),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: SvgPicture.asset(
                            "assets/icon/calendar.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff808080),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            "assets/icon/arrow-down.svg",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 155,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (selectedCategoryId == null) {
                          // Tampilkan pesan error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pilih kategori terlebih dahulu')),
                          );
                          return;
                        }
                        
                        if (selectedDeadline == null) {
                          // Tampilkan pesan error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pilih tanggal deadline terlebih dahulu')),
                          );
                          return;
                        }
                        
                        await taskService.createTask(
                          userId: userData!['id'],
                          name: nameController.text,
                          description: descriptionController.text,
                          deadline: selectedDeadline!.toIso8601String(), // Gunakan format ISO
                          category: selectedCategoryId!,
                        );

                        await taskService.getTaskCountByCategory(selectedCategoryId!);

                        Navigator.pop(context, true); // Kembalikan nilai true untuk trigger refresh
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(225, 5, 38, 89),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Tambah",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}