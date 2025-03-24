import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tugasku/service/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String name;
  final String description;
  final String deadline;
  final String categoryId;
  final String categoryName;

  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.name,
    required this.description,
    required this.deadline,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskCreate _taskService = TaskCreate();
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  bool _isLoadingCategories = true;

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;
  late TextEditingController _categoryController;

  int? _selectedCategoryId;
  DateTime? _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _deadlineController = TextEditingController(
      text: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(widget.deadline)),
    );
    _categoryController = TextEditingController(text: widget.categoryName);
    _selectedCategoryId = int.tryParse(widget.categoryId);
    _selectedDeadline = DateTime.parse(widget.deadline);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _taskService.loadCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;

        // Pastikan _selectedCategoryId ada di _categories
        if (_selectedCategoryId != null) {
          final selectedCategoryExists = _categories.any(
            (category) => category['id'] == _selectedCategoryId,
          );
          if (!selectedCategoryExists) {
            _selectedCategoryId = _categories.isNotEmpty ? _categories[0]['id'] : null;
            _categoryController.text = _categories.isNotEmpty ? _categories[0]['name'] : '';
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kategori: $e')),
      );
    }
  }

  Future<void> _handleSubmitted(String value) async {
    if (value.isNotEmpty) {
      final existingCategory = _categories.firstWhere(
        (c) => c['name'].toString().toLowerCase() == value.toLowerCase(),
        orElse: () => {'id': null},
      );

      if (existingCategory.isNotEmpty && existingCategory['id'] != null) {
        setState(() {
          _selectedCategoryId = existingCategory['id'];
          _categoryController.text = existingCategory['name'];
        });
        return;
      }

      Map<String, dynamic>? newCategory = await _taskService.addNewCategory(
        value,
        _categories,
      );

      if (newCategory != null) {
        setState(() {
          _categories.add(newCategory);
          _selectedCategoryId = newCategory['id'];
          _categoryController.text = newCategory['name'];
        });
      }
    }
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDeadline ?? DateTime.now()),
      );

      if (timePicked != null) {
        final DateTime deadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          timePicked.hour,
          timePicked.minute,
        );

        setState(() {
          _selectedDeadline = deadline;
          _deadlineController.text = DateFormat('dd-MM-yyyy HH:mm').format(deadline);
        });
      }
    }
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih kategori terlebih dahulu')),
        );
        return;
      }

      if (_selectedDeadline == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih tanggal deadline terlebih dahulu')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        await _taskService.updateTask(
          int.parse(widget.taskId),
          _nameController.text,
          _descriptionController.text,
          _selectedDeadline!.toIso8601String(),
          _selectedCategoryId.toString(),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tugas berhasil diperbarui!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui tugas: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff4D4D4D),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Edit Tugas",
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
      body: _isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 645,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        // Autocomplete untuk Kategori
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return _categories
                                .map((c) => c['name'] as String)
                                .where(
                                  (name) => name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase(),
                                      ),
                                );
                          },
                          onSelected: (String value) {
                            final selectedCategory = _categories.firstWhere(
                              (c) => c['name'] == value,
                              orElse: () => {'id': null},
                            );
                            setState(() {
                              _selectedCategoryId = selectedCategory['id'];
                              _categoryController.text = value;
                            });
                          },
                          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                            _categoryController.addListener(() {
                              controller.text = _categoryController.text;
                            });
                            return TextField(
                              controller: _categoryController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(225, 242, 242, 242),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xff808080),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: 'Pilih atau buat kategori',
                                labelStyle: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Color(0xff808080),
                                  fontWeight: FontWeight.w500,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    _handleSubmitted(_categoryController.text);
                                    focusNode.unfocus();
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 15,
                                ),
                              ),
                              onSubmitted: (value) {
                                _handleSubmitted(value);
                                focusNode.unfocus();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // Nama Tugas
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: TextFormField(
                            controller: _nameController,
                            decoration:  InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(225, 242, 242, 242),
                              hintText: "Nama Tugas",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Color(0xff808080),
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff808080),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tugas tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Deskripsi
                        TextFormField(
                          controller: _descriptionController,
                          decoration:  InputDecoration(
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
                              borderSide: BorderSide(
                                color: Color(0xffB3B3B3),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 15,
                            ),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Deskripsi tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Deadline
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: TextFormField(
                            onTap: _showDatePicker,
                            controller: _deadlineController,
                            readOnly: true,
                            decoration:  InputDecoration(
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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Deadline tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 155),
                        // Tombol Simpan Perubahan
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _updateTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(225, 5, 38, 89),
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Simpan Perubahan",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}