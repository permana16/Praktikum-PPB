import 'package:flutter/material.dart';

import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

/// Tampilan dashboard.
/// Widget ini tidak mengatur tema sendiri.
/// Tema tetap terpusat di MaterialApp (modul_02_app.dart).
class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({
    super.key,
    this.themeMode = ThemeMode.light,
    this.onToggleTheme,
  });

  final ThemeMode themeMode;
  final VoidCallback? onToggleTheme;

  @override
  State<AcademicDashboardScreen> createState() =>
      _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState extends State<AcademicDashboardScreen> {
  /// Kategori yang sedang dipilih pada filter.
  String _selectedCategory = 'Semua';

  /// Mengecek apakah aplikasi sedang menggunakan Dark Mode.
  bool get _isDarkMode => widget.themeMode == ThemeMode.dark;

  /// Daftar mata kuliah bersifat tetap.
  /// Data ini bukan state karena tidak berubah selama aplikasi berjalan.
  static final List<Course> _courses = Course.getSampleCourses();

  int get totalSks {
    return Course.getSampleCourses().fold(0, (sum, course) => sum + course.sks);
  }

  /// Menghasilkan daftar mata kuliah sesuai kategori yang dipilih.
  List<Course> get _filteredCourses {
    if (_selectedCategory == 'Semua') {
      return _courses;
    }

    return _courses
        .where((course) => course.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Akademik TRPL',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            tooltip: _isDarkMode ? 'Mode Terang' : 'Mode Gelap',

            /// Aksi diteruskan ke widget parent.
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      /// LayoutBuilder digunakan untuk menentukan layout
      /// berdasarkan lebar ruang yang tersedia.
      body: LayoutBuilder(
        builder: (context, constraints) {
          /// Breakpoint 600 dp:
          /// >= 600 dp  -> layout tablet / landscape
          /// < 600 dp   -> layout smartphone
          if (constraints.maxWidth >= 600) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Kolom kiri: banner profil.
                  const Expanded(
                    flex: 2,
                    child: SingleChildScrollView(child: HeaderBanner()),
                  ),

                  const SizedBox(width: 20),

                  /// Kolom kanan: daftar mata kuliah.
                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,

                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            /// Lebar maksimal setiap card.
                            maxCrossAxisExtent: 340,

                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,

                            /// Tinggi card dibuat tetap agar isi cukup.
                            mainAxisExtent: 240,
                          ),

                      /// Gunakan hasil filter.
                      itemCount: _filteredCourses.length,

                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];

                        return CourseCard(course: course);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          /// Smartphone:
          /// layout 1 kolom vertikal.
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const HeaderBanner(),

              const SizedBox(height: 16),

              /// Filter kategori.
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Semua', 'Teori', 'Praktikum'].map((category) {
                  return ChoiceChip(
                    label: Text(category),

                    selected: _selectedCategory == category,

                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.school),
                      const SizedBox(width: 8),
                      Text(
                        'Total SKS: $totalSks',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              if (totalSks > 24)
                Card(
                  color: Colors.red.shade100,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Peringatan: Total SKS melebihi '
                            'batas maksimal 24 SKS per semester!',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              /// Jumlah mata kuliah mengikuti hasil filter.
              Text(
                'Mata Kuliah Semester 3 '
                '(${_filteredCourses.length} Terdaftar)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// Daftar card mengikuti hasil filter.
              ..._filteredCourses.map((course) => CourseCard(course: course)),
            ],
          );
        },
      ),
    );
  }
}
