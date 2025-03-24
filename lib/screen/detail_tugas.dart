import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/screen/edit_task.dart';
import 'package:tugasku/screen/homepage.dart';
import 'package:tugasku/service/task_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DetailTugas extends StatefulWidget {
  final String taskId;
  final String name;
  final String category;
  final String description;
  final String deadline;
  final String categoryId;
  final String? imageUrl;

  final TaskCreate _taskService = TaskCreate();

   DetailTugas({
    super.key,
    required this.taskId,
    required this.name,
    required this.category,
    required this.description,
    required this.deadline,
    required this.categoryId,
    this.imageUrl,
  });

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  bool _isLoading = false;
  File? _imageFile;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrl = null;
      });

      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newImageUrl = await widget._taskService.uploadTaskImage(_imageFile!, widget.taskId);

      if (newImageUrl != null) {
        setState(() {
          _imageUrl = newImageUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengupload gambar: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime deadlineDate = DateTime.parse(widget.deadline);
    String remainingTime = widget._taskService.formatDuration(deadlineDate);

    Color timeColor = const Color(0xff052659);
    Color bgTimeColor = const Color(0x20052659);
    if (deadlineDate.difference(DateTime.now()).inDays < 2) {
      timeColor = const Color(0xff991B1B);
      bgTimeColor = const Color(0x20991B1B);
    }

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
          "Detail",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            fontSize: 22,
            color: Color(0xff4d4d4d),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffF7F7F7),
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: const Color(0xffF7F7F7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    side: const BorderSide(width: 1, color: Color(0xffE6E6E6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text(
                      widget.category,
                      style: const TextStyle(
                        color: Color(0xff4d4d4d),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: bgTimeColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: timeColor),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/Icondeadline.svg",
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(timeColor, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          remainingTime,
                          style: TextStyle(
                            color: timeColor,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Poppins",
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Color(0xff4D4D4D),
                ),
              ),
              const SizedBox(height: 51),
              const Text(
                "Foto",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Poppins",
                  color: Color(0xff333333),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 300,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    _imageFile!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _imageFile = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          : _imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Image.network(
                                        _imageUrl!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.white),
                                        onPressed: () async {
                                          await widget._taskService.deleteTaskImage(widget.taskId);
                                          setState(() {
                                            _imageUrl = null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Upload Image",
                                      style: TextStyle(
                                        color: Color(0xff808080),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.5,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.upload, color: Colors.grey.shade600),
                                  ],
                                ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(
                              taskId: widget.taskId,
                              name: widget.name,
                              description: widget.description,
                              deadline: widget.deadline,
                              categoryId: widget.categoryId,
                              categoryName: widget.category,
                            ),
                          ),
                        );

                        if (result == true) {
                          Navigator.pop(context, true);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Color(0xff052659),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await widget._taskService.completeTask(int.parse(widget.taskId));
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Tugas selesai!")),
                                );
                                Navigator.pop(context, true);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Gagal menyelesaikan tugas: $e")),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff052659),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                              "Selesai",
                              style: TextStyle(
                                color: Color(0xffffffff),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}