import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

//status enum
enum TaskStatus {
  uncompleted,
  completed,
}

//extension konversi antara string dan enum
extension TaskStatusExtension on TaskStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static TaskStatus fromString(String status) {
    return TaskStatus.values.firstWhere((e) => e.toShortString() == status,
        orElse: () => TaskStatus.uncompleted);
  }
}

class TaskCreate {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createTask(
      {required String userId,
      required String name,
      required String description,
      required String deadline,
      required int category,
      String? image}) async {
    try {
      // Ubah string deadline menjadi DateTime
      DateTime deadlineDate = DateTime.parse(deadline);

      await _supabase.from('assignment').insert([
        {
          "name": name,
          "description": description,
          "deadline": deadlineDate.toIso8601String(),
          "category_id": category,
          "user_id": userId,
          "status": TaskStatus.uncompleted.toShortString(),
          "image": image
        }
      ]);
    } catch (e) {
      debugPrint("Error saat menambahkan tugas: $e");
    }
  }

  Future<List<Map<String, dynamic>>> loadCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select('id, name')
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      return response
          .map<Map<String, dynamic>>((row) => {
                'id': row['id'],
                'name': row['name'],
              })
          .toList();
    } catch (error) {
      debugPrint("Error loading categories: $error");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadAssignments(String userId) async {
    try {
      final response = await _supabase
          .from('assignment')
          .select('*, categories(name, id)') // Tetap sama
          .eq('user_id', userId)
          .eq('status', TaskStatus.uncompleted.toShortString())
          .order('created_at', ascending: false);

      DateTime now = DateTime.now();

      //Filter tugas yang unexpired
      List<Map<String, dynamic>> activeTasks =
          response.map<Map<String, dynamic>>((row) => row).where((task) {
        DateTime deadline = DateTime.parse(task['deadline']);
        return deadline.isAfter(now); //menampilkan tugas yang unexpired
      }).toList();

      return activeTasks;
    } catch (error) {
      debugPrint("Error loading assignments: $error");
      return [];
    }
  }

  // Methods that need changes in task_service.dart

  Future<String?> uploadTaskImage(File imageFile, String taskId) async {
    try {
      final String fileName =
          'task_${taskId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String storagePath = 'uploads/$fileName';

      // Upload file ke Supabase Storage
      final response =
          await _supabase.storage.from('image').upload(storagePath, imageFile);
      debugPrint("Upload response: $response");

      // Dapatkan URL publik untuk gambar
      final String imageUrl =
          _supabase.storage.from('image').getPublicUrl(storagePath);

      // CHANGED: Parse taskId to int before using it to update the record
      await _supabase
          .from('assignment')
          .update({'image': imageUrl}).eq('id', int.parse(taskId));

      return imageUrl;
    } catch (e) {
      debugPrint("Error uploading task image: $e");
      return null;
    }
  }

  // Method untuk hapus gambar tugas
  Future<bool> deleteTaskImage(String taskId) async {
    try {
      // Dapatkan data tugas termasuk URL gambar
      final response = await _supabase
          .from('assignment')
          .select('image')
          .eq('id', int.parse(taskId))
          .single();

      final String? imageUrl = response['image'];

      if (imageUrl != null) {
        // Extract path dari URL
        final Uri uri = Uri.parse(imageUrl);
        final String imagePath = uri.pathSegments.sublist(2).join('/');

        // Hapus file dari storage
        await _supabase.storage.from('image').remove([imagePath]);

        // Update task dengan null image
        await _supabase
            .from('assignment')
            .update({'image': null}).eq('id', int.parse(taskId));

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Error deleting task image: $e");
      return false;
    }
  }

  //Task completed
  Future<bool> completeTask(int taskId) async {
    try {
      DateTime now = DateTime.now();
      await _supabase.from('assignment').update({
        'status': TaskStatus.completed.toShortString(),
        'completed_at': now.toIso8601String()
      }).eq('id', taskId);
      return true;
    } catch (e) {
      debugPrint("Error completed assignment: $e");
      return false;
    }
  }

  //Load tugas yang sudah selesai/expired
  Future<List<Map<String, dynamic>>> loadHistoryTasks(String userId) async {
    try {
      final response = await _supabase
          .from('assignment')
          .select('*, categories(name, id)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      DateTime now = DateTime.now();

      //filter menampilkan tugas yang sudah selesai/expired
      List<Map<String, dynamic>> historyTask =
          response.map<Map<String, dynamic>>((row) => row).where((task) {
        DateTime deadline = DateTime.parse(task['deadline']);
        bool isCompleted =
            task['status'] == TaskStatus.completed.toShortString();
        bool isExpired = deadline.isBefore(now) &&
            task['status'] == TaskStatus.uncompleted.toShortString();

        return isCompleted || isExpired;
      }).toList();

      return historyTask;
    } catch (error) {
      debugPrint("Error Load history task $error");
      return [];
    }
  }

  bool isTaskExpired(Map<String, dynamic> task) {
    DateTime deadline = DateTime.parse(task['deadline']);
    DateTime now = DateTime.now();
    return deadline.isBefore(now) &&
        task['status'] == TaskStatus.uncompleted.toShortString();
  }

  // Menghitung jumlah tugas per kategori
  Map<String, int> countTaskByCategory(List<Map<String, dynamic>> tasks) {
    Map<String, int> result = {};

    for (var task in tasks) {
      // Pastikan task memiliki data categories
      if (task['categories'] != null) {
        String categoryName = task['categories']['name'];

        // Jika kategori sudah ada di map, tambahkan count
        if (result.containsKey(categoryName)) {
          result[categoryName] = result[categoryName]! + 1;
        } else {
          // Jika kategori belum ada, inisialisasi dengan 1
          result[categoryName] = 1;
        }
      }
    }

    return result;
  }

  Future<Map<String, dynamic>?> addNewCategory(
      String newCategory, List<Map<String, dynamic>> categories) async {
    try {
      final existingCategory = categories.firstWhere(
        (c) => c['name'].toLowerCase() == newCategory.toLowerCase(),
        orElse: () => <String, dynamic>{},
      );

      if (existingCategory.isNotEmpty) {
        return existingCategory;
      }

      final response = await _supabase
          .from('categories')
          .insert(
              {'name': newCategory, 'user_id': _supabase.auth.currentUser!.id})
          .select('id, name')
          .maybeSingle();

      if (response != null) {
        return {'id': response['id'], 'name': response['name']};
      }
    } catch (error) {
      debugPrint("Error adding category: $error");
    }
    return null;
  }

  Future<void> updateTask(int id, String name, String description,
      String deadline, String category) async {
    try {
      // Ubah string deadline menjadi DateTime
      DateTime deadlineDate = DateTime.parse(deadline);

      int categoryId = int.parse(category);

      await _supabase.from('assignment').update({
        "name": name,
        "description": description,
        "deadline": deadlineDate.toIso8601String(),
        "category_id": categoryId
      }).eq('id', id);
    } catch (e) {
      debugPrint("Error saat memperbarui tugas: $e");
    }
  }

  // Menghitung jumlah tugas berdasarkan kategori tertentu
  Future<String> getTaskCountByCategory(int categoryId) async {
    try {
      DateTime now = DateTime.now();

      final response = await _supabase
          .from('assignment')
          .select('id')
          .eq('category_id', categoryId)
          .eq('status', TaskStatus.uncompleted.toShortString());

      final activeTasks = response.where((task) {
        DateTime deadline = DateTime.parse(task['deadline']);
        return deadline.isAfter(now);
      }).toList();

      int count = activeTasks.length;
      return '$count Tugas';
    } catch (e) {
      debugPrint("Error saat menghitung tugas per kategori: $e");
      return '0 Tugas';
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _supabase.from('assignment').delete().eq('id', id);
    } catch (e) {
      debugPrint("Error saat menghapus tugas: $e");
    }
  }

  // Format durasi/deadline
  String formatDuration(DateTime deadline) {
    DateTime now = DateTime.now();
    Duration remainingTime = deadline.difference(now);

    int days = remainingTime.inDays;
    int hours = remainingTime.inHours % 24;
    int minutes = remainingTime.inMinutes % 60;

    if (days > 0) {
      return '$days' 'D';
    } else if (hours > 0) {
      return '$hours jam $minutes menit';
    } else {
      return '$minutes menit';
    }
  }
}
