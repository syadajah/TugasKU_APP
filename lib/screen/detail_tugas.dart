import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugasku/screen/homepage.dart';
import 'package:tugasku/service/task_service.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan package ini
import 'dart:io';

class DetailTugas extends StatefulWidget {
  final String category;
  final String name;
  final String description;
  final String deadline;
  final String taskId;
  final String? imageUrl; // Tambahkan parameter untuk imageUrl

  final TaskCreate _taskService = TaskCreate();
  DetailTugas({
    super.key,
    required this.category,
    required this.name,
    required this.description,
    required this.deadline,
    required this.taskId,
    this.imageUrl, // Tambahkan parameter opsional untuk imageUrl
  });

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  bool _isLoading = false;
  File? _imageFile; // Untuk menyimpan file gambar lokal
  String? _imageUrl; // Untuk menyimpan URL gambar dari Supabase
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Set initial image URL jika ada
    _imageUrl = widget.imageUrl;
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrl = null; // Reset URL gambar karena kita punya gambar baru
      });

      // Upload gambar ke Supabase dan update tugas
      _uploadImage();
    }
  }

  // Fungsi untuk upload gambar ke Supabase
  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload gambar dan dapatkan URL
      final newImageUrl =
          await widget._taskService.uploadTaskImage(_imageFile!, widget.taskId);

      if (newImageUrl != null) {
        setState(() {
          _imageUrl = newImageUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal mengupload gambar: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse deadline dari string ke DateTime
    DateTime deadlineDate = DateTime.parse(widget.deadline);

    // Hitung sisa waktu
    String remainingTime = widget._taskService.formatDuration(deadlineDate);

    // Tentukan warna berdasarkan sisa waktu
    Color timeColor = Color(0xff052659);
    Color bgTimeColor = Color(0x20052659);
    if (deadlineDate.difference(DateTime.now()).inDays < 2) {
      timeColor = Color(0xff991B1B);
      bgTimeColor = Color(0x20991B1B);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff4D4D4D),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Detail",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontSize: 22,
                color: Color(0xff4d4d4d))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xffF7F7F7),
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Color(0xffF7F7F7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Chip(
                    side: BorderSide(width: 1, color: Color(0xffE6E6E6)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    label: Text(
                      widget.category,
                      style: TextStyle(
                          color: Color(0xff4d4d4d),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                          colorFilter:
                              ColorFilter.mode(timeColor, BlendMode.srcIn),
                        ),
                        SizedBox(width: 4),
                        Text(remainingTime,
                            style: TextStyle(
                                color: timeColor,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(widget.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Color(0xff333333))),
              SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: Color(0xff4D4D4D)),
              ),
              SizedBox(height: 51),
              Text("Foto",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Color(0xff333333))),
              SizedBox(height: 20),

              // Widget container untuk upload atau tampilkan gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 300, // Tambahkan tinggi untuk menampilkan gambar
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _imageFile != null
                          // Tampilkan gambar yang baru dipilih
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
                                    icon:
                                        Icon(Icons.close, color: Colors.white),
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
                              // Tampilkan gambar dari URL Supabase
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
                                        icon: Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () async {
                                          await widget._taskService
                                              .deleteTaskImage(widget.taskId);
                                          setState(() {
                                            _imageUrl = null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              // Tampilkan UI upload jika tidak ada gambar
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,
                                        color: Colors.grey.shade600),
                                    SizedBox(width: 8),
                                    Text("Upload Image",
                                        style: TextStyle(
                                            color: Color(0xff808080),
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.5,
                                            fontSize: 12)),
                                    SizedBox(width: 8),
                                    Icon(Icons.upload,
                                        color: Colors.grey.shade600),
                                  ],
                                ),
                ),
              ),

              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("Edit",
                          style: TextStyle(
                              color: Color(0xff052659),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              fontSize: 12)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              bool success = await widget._taskService
                                  .completeTask(int.parse(widget.taskId));

                              if (!mounted) return;

                              setState(() {
                                _isLoading = false;
                              });

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Tugas selesai!")));
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()),
                                    (route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Gagal menyelesaikan tugas!")));
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff052659),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text("Selesai",
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                  fontSize: 12)),
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