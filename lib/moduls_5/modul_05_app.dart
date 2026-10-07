import 'package:flutter/material.dart';
import 'package:tugas_362558302118_yoga_permana/moduls_5/models/screens/task_list_screen.dart';
import 'package:tugas_362558302118_yoga_permana/moduls_5/models/services/task_storage.dart';
// Tugas:
// - Aksi Tambah
// - Aksi Hapus
// - Kondisi Muat Gagal
// - Kondisi Data Kosong

class Modul05App extends StatelessWidget {
  const Modul05App({super.key});

  @override
  Widget build(BuildContext context) {
    const bool lambat = bool.fromEnvironment('LAMBAT');
    const TaskStorage storage = TaskStorage(
      tunda: lambat ? Duration(seconds: 2) : Duration.zero,
    );
    return MaterialApp(
      title: 'Modul 05 - Tugas Praktikum',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const TaskListScreen(storage: storage),
    );
  }
}