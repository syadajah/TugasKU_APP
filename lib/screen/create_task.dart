import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tugasku/Auth/auth_service.dart';
import 'package:tugasku/screen/homepage.dart';
import 'package:tugasku/service/task_service.dart';

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

  void getCategories() {
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

      Map<String, dynamic>? newCategory =
          await taskService.addNewCategory(value, categories);

      if (newCategory != null) {
        setState(() {
          categories.add(newCategory);
          selectedCategoryId = newCategory['id'];
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
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: 50,
                //   child: TextField(
                //     onSubmitted: (Value) => print(Value),
                //     controller: categoryController,
                //     decoration: InputDecoration(
                //       filled: true,
                //       fillColor: Color.fromARGB(225, 242, 242, 242),
                //       hintText: "Kategori",
                //       hintStyle: TextStyle(
                //         fontFamily: "Poppins",
                //         fontSize: 12,
                //         color: Color(0xff808080),
                //         fontWeight: FontWeight.w500,
                //       ),
                //       prefixIcon: Padding(
                //         padding: EdgeInsets.all(13.0),
                //         child: SizedBox(
                //           width: 15,
                //           height: 15,
                //           child: SvgPicture.asset(
                //             "assets/icon/collection.svg",
                //             fit: BoxFit.contain,
                //           ),
                //         ),
                //       ),
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Color(0xff808080),
                //           width: 0.5,
                //         ),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       suffixIcon: Padding(
                //         padding: EdgeInsets.all(10.0),
                //         child: SizedBox(
                //           width: 20,
                //           height: 20,
                //           child: SvgPicture.asset(
                //             "assets/icon/arrow-down.svg",
                //             fit: BoxFit.contain,
                //           ),
                //         ),
                //       ),
                //       contentPadding:
                //           EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                //     ),
                //   ),
                // ),
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
                        labelText: 'Select or enter category',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            _handleSubmitted(controller.text);
                            focusNode.unfocus();
                          },
                        ),
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
                    controller: deadlineController,
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
                      onPressed: () {
                        if (selectedCategoryId == null) {
                          debugPrint("User haven't select category");
                          return;
                        }

                        taskService.createTask(
                          userId: userData!['id'],
                          name: nameController.text,
                          description: descriptionController.text,
                          deadline: deadlineController.text,
                          category: selectedCategoryId!,
                        );
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => Homepage(
                        //           name: nameController.text,
                        //           description: descriptionController.text,
                        //           deadline: deadlineCodntroller.text,
                        //           category: categoryController.text,
                        //         )));
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
