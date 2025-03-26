import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

// Status enum
enum TaskStatus {
  uncompleted,
  completed,
}

// Extension konversi antara string dan enum
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
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi notifikasi lokal
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Tampilkan notifikasi langsung
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          channelDescription: 'channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> createTask({
    required String userId,
    required String name,
    required String description,
    required String deadline,
    required int category,
    String? image,
  }) async {
    try {
      // Ubah string deadline menjadi DateTime
      DateTime deadlineDate = DateTime.parse(deadline);

      // Simpan tugas ke database
      await _supabase.from('assignment').insert([
        {
          "name": name,
          "description": description,
          "deadline": deadlineDate.toIso8601String(),
          "category_id": category,
          "user_id": userId,
          "status": TaskStatus.uncompleted.toShortString(),
          "image": image,
          "is_notified": false,
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
          .eq('status', TaskStatus.uncompleted.toShortString())
          .order('created_at', ascending: false);

      DateTime now = DateTime.now();

      // Filter tugas yang belum Expired
      List<Map<String, dynamic>> activeTasks =
          response.map<Map<String, dynamic>>((row) => row).where((task) {
        DateTime deadline = DateTime.parse(task['deadline']);
        return deadline.isAfter(now);
      }).toList();

      // Periksa tugas yang mendekati deadline dan tampilkan notifikasi
      for (var task in activeTasks) {
        DateTime deadline = DateTime.parse(task['deadline']);
        final difference = deadline.difference(now).inHours;

        if (difference <= 24 &&
            difference > 0 &&
            !(task['is_notified'] ?? false)) {
          await showNotification(
            id: task['id'].hashCode,
            title: 'Ingat Tugas! ⏱️',
            body:
                'Deadline Tugas "${task['name']}" di kategori "${task['categories']['name']}" Akan terlewat besok!',
          );

          // Update status notifikasi di database
          await updateTaskNotificationStatus(task['id'], true);
        }
      }

      return activeTasks;
    } catch (error) {
      debugPrint("Error Memuat gambar: $error");
      return [];
    }
  }

  Future<String?> uploadTaskImage(File imageFile, String taskId) async {
    try {
      final String fileName =
          'task_${taskId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String storagePath = 'uploads/$fileName';

      final response =
          await _supabase.storage.from('image').upload(storagePath, imageFile);
      debugPrint("Upload response: $response");

      final String imageUrl =
          _supabase.storage.from('image').getPublicUrl(storagePath);

      await _supabase
          .from('assignment')
          .update({'image': imageUrl}).eq('id', int.parse(taskId));

      return imageUrl;
    } catch (e) {
      debugPrint("Error Mengunggah gambar: $e");
      return null;
    }
  }

  Future<bool> deleteTaskImage(String taskId) async {
    try {
      final response = await _supabase
          .from('assignment')
          .select('image')
          .eq('id', int.parse(taskId))
          .single();

      final String? imageUrl = response['image'];

      if (imageUrl != null) {
        final Uri uri = Uri.parse(imageUrl);
        final String imagePath = uri.pathSegments.sublist(2).join('/');

        await _supabase.storage.from('image').remove([imagePath]);

        await _supabase
            .from('assignment')
            .update({'image': null}).eq('id', int.parse(taskId));

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Error Menghapus gambar: $e");
      return false;
    }
  }

  Future<bool> completeTask(int taskId) async {
    try {
      DateTime now = DateTime.now();
      await _supabase.from('assignment').update({
        'status': TaskStatus.completed.toShortString(),
        'completed_at': now.toIso8601String(),
      }).eq('id', taskId);
      return true;
    } catch (e) {
      debugPrint("Error dalam menyelesaikan tugas: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> loadCompletedTasks(String userId) async {
    try {
      final response = await _supabase
          .from('assignment')
          .select('*, categories(*)')
          .eq('user_id', userId)
          .not('completed_at', 'is', null)
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      debugPrint('Error memuat tugas yang selesai: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadHistoryTasks(String userId) async {
    try {
      final response = await _supabase
          .from('assignment')
          .select('*, categories(name, id)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      DateTime now = DateTime.now();

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
      debugPrint("Error Memuat Riwayat Tugas $error");
      return [];
    }
  }

  bool isTaskExpired(Map<String, dynamic> task) {
    DateTime deadline = DateTime.parse(task['deadline']);
    DateTime now = DateTime.now();
    return deadline.isBefore(now) &&
        task['status'] == TaskStatus.uncompleted.toShortString();
  }

  Map<String, int> countTaskByCategory(List<Map<String, dynamic>> tasks) {
    Map<String, int> result = {};

    for (var task in tasks) {
      if (task['categories'] != null) {
        String categoryName = task['categories']['name'];

        if (result.containsKey(categoryName)) {
          result[categoryName] = result[categoryName]! + 1;
        } else {
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
      debugPrint("Error Ketika menambahkan kategori : $error");
    }
    return null;
  }

  Future<void> updateTask(int id, String name, String description,
      String deadline, String category) async {
    try {
      DateTime deadlineDate = DateTime.parse(deadline);
      int categoryId = int.parse(category);

      await _supabase.from('assignment').update({
        "name": name,
        "description": description,
        "deadline": deadlineDate.toIso8601String(),
        "category_id": categoryId,
      }).eq('id', id);
    } catch (e) {
      debugPrint("Error saat memperbarui tugas: $e");
    }
  }

  Future<void> updateTaskNotificationStatus(int id, bool isNotified) async {
    try {
      await _supabase
          .from('assignment')
          .update({'is_notified': isNotified}).eq('id', id);
    } catch (e) {
      debugPrint("Error saat memperbarui status notifikasi: $e");
    }
  }

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

  String formatDuration(DateTime deadline) {
    DateTime now = DateTime.now();
    Duration remainingTime = deadline.difference(now);

    int days = remainingTime.inDays;
    int hours = remainingTime.inHours % 24;
    int minutes = remainingTime.inMinutes % 60;

    if (days > 0) {
      return '$days D';
    } else if (hours > 0) {
      return '$hours jam $minutes menit';
    } else {
      return '$minutes menit';
    }
  }
}
