import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskCreate {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createTask({
    required String userId,
    required String name,
    required String description,
    required String deadline,
    required int category,
  }) async {
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
          .select('*, categories(name, id)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<Map<String, dynamic>>((row) => row).toList();
    } catch (error) {
      debugPrint("Error loading assignments: $error");
      return [];
    }
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

      await _supabase.from('assignment').update({
        "name": name,
        "description": description,
        "deadline": deadlineDate.toIso8601String(),
        "category_id": category
      }).eq('id', id);
    } catch (e) {
      debugPrint("Error saat memperbarui tugas: $e");
    }
  }

  // Menghitung jumlah tugas berdasarkan kategori tertentu
  Future<String> getTaskCountByCategory(int categoryId) async {
    try {
      final response = await _supabase
          .from('assignment')
          .select('id')
          .eq('category_id', categoryId);

      int count = response.length;
      return '$count Tugas';
    } catch (e) {
      debugPrint("Error saat menghitung tugas per kategori: $e");
      return '0 Tugas';
    }
  }

  void validateTaskData(Map<String, dynamic> task) {
    final requiredFields = [
      'user_id',
      'name',
      'description',
      'deadline',
      'category_id'
    ];
    final missingFields =
        requiredFields.where((field) => task[field] == null).toList();

    if (missingFields.isNotEmpty) {
      debugPrint("Missing required fields: $missingFields");
      throw Exception("Task data missing required fields: $missingFields");
    }

    try {
      DateTime.parse(task['deadline']);
    } catch (e) {
      debugPrint("Invalid deadline format: ${task['deadline']}");
      throw Exception("Invalid deadline format in task data");
    }
  }

  Future<bool> completeTask(int taskId) async {
    try {
      debugPrint("Attempting to complete task with ID: $taskId");

      // Get Task From assignment (Data tugas dari tabel assignment)
      final task = await _supabase
          .from('assignment')
          .select('*')
          .eq('id', taskId)
          .single();

      debugPrint("Task found: ${task.toString()}");

      final taskData = {
        'user_id': task['user_id'],
        'name': task['name'],
        'description': task['description'],
        'deadline': task['deadline'],
        'category_id': task['category_id'],
        'completed_at': DateTime.now().toIso8601String(),
        'task_id': taskId.toString(),
      };

      // Insert into completed_task (Insert data assignment ke table completed_task)
      await _supabase.from('completed_task').insert(taskData);
      debugPrint("Task inserted into completed_task table");

      // Delete data assignment
      await _supabase.from('assignment').delete().eq('id', taskId);
      debugPrint("Task deleted from assignment table");

      return true;
    } catch (e) {
      debugPrint("Complete error in completeTask: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> loadCompletedTasks(String userId) async {
    try {
      List<Map<String, dynamic>> results = [];

      try {
        final response = await _supabase
            .from('task_completed')
            .select('*, categories(name, id)')
            .eq('user_id', userId)
            .order('completed_at', ascending: false);

        results = response.map<Map<String, dynamic>>((row) => row).toList();
        debugPrint("Found ${results.length} tasks in task_completed table");
      } catch (e) {
        debugPrint("Error loading from task_completed: $e");
      }

      if (results.isEmpty) {
        try {
          final response = await _supabase
              .from('completed_task')
              .select('*, categories(name, id)')
              .eq('user_id', userId)
              .order('completed_at', ascending: false);

          results = response.map<Map<String, dynamic>>((row) => row).toList();
          debugPrint("Found ${results.length} tasks in completed_task table");
        } catch (e) {
          debugPrint("Error loading from completed_task: $e");
        }
      }

      return results;
    } catch (error) {
      debugPrint("Error loading completed tasks: $error");
      return [];
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _supabase.from('assignment').delete().eq('id', id);
    } catch (e) {
      debugPrint("Error saat menghapus tugas: $e");
    }
  }

  // Fungsi baru untuk format durasi
  String formatDuration(DateTime deadline) {
    DateTime now = DateTime.now();
    Duration remainingTime = deadline.difference(now);

    int days = remainingTime.inDays;
    int hours = remainingTime.inHours % 24;
    int minutes = remainingTime.inMinutes % 60;

    // Cek jika tanggal sudah lewat
    if (remainingTime.isNegative) {
      return 'Lewat deadline';
    }

    if (days > 0) {
      return '$days' 'D';
    } else if (hours > 0) {
      return '$hours jam $minutes menit';
    } else {
      return '$minutes menit';
    }
  }
}
