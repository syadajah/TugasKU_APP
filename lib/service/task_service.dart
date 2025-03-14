import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskCreate {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createTask(
      String name, String description, String deadline, String category) async {
    try {
      await _supabase.from('assignment').insert([
        {
          "name": name,
          "description": description,
          "deadline": deadline,
          "category": category
        }
      ]);
    } catch (e) {
      debugPrint("Error saat menambahkan tugas: $e");
    }
  }

  Future<void> updateTask(int id, String name, String description,
      String deadline, String category) async {
    try {
      await _supabase.from('assignment').update({
        "name": name,
        "description": description,
        "deadline": deadline,
        "category": category
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
}
