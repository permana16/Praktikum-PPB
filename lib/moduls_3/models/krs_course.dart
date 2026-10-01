class KrsCourse {
  const KrsCourse({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.sks,
    this.description = '',
  });

  final String code;
  final String name;
  final String lecturer;
  final int sks;
  final String description;

  static List<KrsCourse> getInitialCourses() {
    return const [
      KrsCourse(
        code: 'TRPL501',
        name: 'Pemrograman Perangkat Bergerak',
        lecturer: 'Sepyan Purnama Kristanto, M.Kom.',
        sks: 3,
      ),
      KrsCourse(
        code: 'TRPL123',
        name: 'Basis Data Lanjut',
        lecturer: 'Eka Mistiko',
        sks: 4,
      ),
      KrsCourse(
        code: 'TRPL508',
        name: 'Interoperabilitas',
        lecturer: 'I wayan Suardinata',
        sks: 4,
      ),
    ];
  }
}
