import 'package:flutter/material.dart';
import '../models/krs_course.dart';
import '../widgets/krs_course_tile.dart';
import 'add_krs_screen.dart';
import 'course_detail_screen.dart';

const int batasSksSemester = 24;
const int ambangPeringatanSks = 21;

class KrsListScreen extends StatefulWidget {
  const KrsListScreen({super.key});

  @override
  State<KrsListScreen> createState() => _KrsListScreenState();
}

class _KrsListScreenState extends State<KrsListScreen> {
  /// Perhatikan `List<KrsCourse>.of(...)`.
  /// `getInitialCourses()` mengembalikan list `const`, dan list `const`
  /// TIDAK DAPAT DIUBAH. Tanpa penyalinan ini, add() dan removeWhere()
  /// akan melempar UnsupportedError saat dijalankan.

  int? _filterSks;
  bool _urutkanAscending = true;
  bool _isLoading = false;  

  final List<KrsCourse> _courses = List<KrsCourse>.of(
    KrsCourse.getInitialCourses(),
  );

  int get _totalSks =>
      _courses.fold(0, (jumlah, course) => jumlah + course.sks);

Future<void> _bukaDetail(KrsCourse course) async {
  final int? sksBaru = await Navigator.push<int>(
    context,
    MaterialPageRoute<int>(
      builder: (_) => CourseDetailScreen(course: course),
    ),
  );

  if (!mounted || sksBaru == null) return;

  final int index = _courses.indexWhere(
    (item) => item.code == course.code,
  );

  if (index == -1) return;

  final KrsCourse courseLama = _courses[index];

  final KrsCourse courseBaru = KrsCourse(
    code: courseLama.code,
    name: courseLama.name,
    lecturer: courseLama.lecturer,
    sks: sksBaru,
    description: courseLama.description,
  );

  setState(() {
    _courses[index] = courseBaru;
  });

  _tampilkanPesan(
    '${courseLama.name} sekarang menjadi $sksBaru SKS.',
  );
}

  // Menerima hasil lewat Navigator.pop.
  Future<void> _bukaFormTambah() async {
    final KrsCourse? courseBaru = await Navigator.push<KrsCourse>(
      context,
      MaterialPageRoute<KrsCourse>(builder: (_) => const AddKrsScreen()),
    );

    // Tombol kembali ditekan tanpa menyimpan.
    if (!mounted || courseBaru == null) return;

    final bool duplikat = _courses.any(
      (course) => course.code.toUpperCase() == courseBaru.code.toUpperCase(),
    );

    if (duplikat) {
      _tampilkanPesan('Kode ${courseBaru.code} sudah ada di rencana studi.');
      return;
    }

    final int totalBaru = _totalSks + courseBaru.sks;

    if (totalBaru > batasSksSemester) {
      _tampilkanPesan(
        'Total SKS akan menjadi $totalBaru, melebihi batas '
        '$batasSksSemester SKS.',
      );
      return;
    }

    setState(() => _courses.add(courseBaru));

    _tampilkanPesan('${courseBaru.name} ditambahkan ke rencana studi.');
  }

  Future<void> _konfirmasiHapus(KrsCourse course) async {
    // Ambil warna SEBELUM await, agar tidak memakai context
    // setelah jeda asynchronous.
    final Color errorColor = Theme.of(context).colorScheme.error;

    final bool? dikonfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus mata kuliah?'),
        content: Text(
          'Yakin ingin membatalkan pengambilan "${course.name}" '
          '(${course.sks} SKS)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: errorColor),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || dikonfirmasi != true) return;

    setState(() => _courses.removeWhere((item) => item.code == course.code));

    _tampilkanPesan('${course.name} dihapus dari rencana studi.');
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  void _ubahFilterSks(int? sks) {
    setState(() {
      _filterSks = sks;
    });
  }

  void _ubahUrutan() {
    setState(() {
      _urutkanAscending = !_urutkanAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool mendekatiBatas = _totalSks >= ambangPeringatanSks;

    final List<KrsCourse> displayedCourses = _courses
        .where((course) => _filterSks == null || course.sks == _filterSks)
        .toList();

    // Sorting berdasarkan kode mata kuliah.
    displayedCourses.sort((a, b) {
      final int hasil = a.code.compareTo(b.code);

      return _urutkanAscending ? hasil : -hasil;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Studi'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Chip(label: Text('$_totalSks / $batasSksSemester SKS')),
            ),
          ),
        ],
      ),
      body: _courses.isEmpty
          ? const Center(
              child: Text('Belum ada mata kuliah dalam rencana studi.'),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Filter Semua
                      FilterChip(
                        label: const Text('Semua'),
                        selected: _filterSks == null,
                        onSelected: (_) {
                          _ubahFilterSks(null);
                        },
                      ),

                      // Filter 1-6 SKS
                      for (int sks = 1; sks <= 6; sks++)
                        FilterChip(
                          label: Text('$sks SKS'),
                          selected: _filterSks == sks,
                          onSelected: (selected) {
                            _ubahFilterSks(selected ? sks : null);
                          },
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: _ubahUrutan,
                      icon: Icon(
                        _urutkanAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      label: Text(_urutkanAscending ? 'Kode A–Z' : 'Kode Z–A'),
                    ),
                  ),
                ),

                Expanded(
                  child: displayedCourses.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada mata kuliah '
                            'dengan filter tersebut.',
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: displayedCourses.length,
                          itemBuilder: (context, index) {
                            final course = displayedCourses[index];

                            return KrsCourseTile(
                              course: course,
                              onTap: () => _bukaDetail(course),
                              onDelete: () => _konfirmasiHapus(course),
                            );
                          },
                        ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaFormTambah,
        icon: const Icon(Icons.add),
        label: Text(mendekatiBatas ? 'Tambah' : 'Tambah Mata Kuliah'),
      ),
    );
  }
}
