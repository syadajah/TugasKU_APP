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
          "deadline": deadlineDate.toIso8601String(), // Simpan dalam format ISO
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

      return response
          .map<Map<String, dynamic>>((row) => row)
          .toList();
    } catch (error) {
      debugPrint("Error loading assignments: $error");
      return [];
    }
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
          .insert({'name': newCategory})
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
      return '$days';
    }
    
    if (days > 0) {
      return '$days''D';
    } else if (hours > 0) {
      return '$hours jam $minutes menit';
    } else {
      return '$minutes menit';
    }
  }
}