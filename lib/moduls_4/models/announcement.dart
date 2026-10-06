class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.date,
    required this.readCount,
  });

  final int id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String date;
  final int readCount;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] as String? ?? 'Tanpa Judul',
      content:
          json['content'] as String? ??
          json['body'] as String? ??
          '',
      author: json['author'] as String? ?? 'Admin Jurusan',
      category: json['category'] as String? ?? 'Akademik',
      date: json['date'] as String? ?? '2026-09-01',
      readCount: json['readCount'] is int
          ? json['readCount'] as int
          : 0,
    );
  }

  static List<Announcement> getSampleAnnouncements() {
    return const [
      Announcement(
        id: 1,
        title: 'Jadwal Perkuliahan Semester',
        content: 'Jadwal perkuliahan semester terbaru.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Akademik',
        date: '2026-09-01',
        readCount: 37,
      ),
      Announcement(
        id: 2,
        title: 'Informasi Beasiswa',
        content: 'Pendaftaran beasiswa mahasiswa telah dibuka.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Beasiswa',
        date: '2026-09-02',
        readCount: 74,
      ),
      Announcement(
        id: 3,
        title: 'Kegiatan Mahasiswa',
        content: 'Informasi kegiatan mahasiswa.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Kegiatan',
        date: '2026-09-03',
        readCount: 111,
      ),
      Announcement(
        id: 4,
        title: 'Prestasi Mahasiswa',
        content: 'Selamat kepada mahasiswa yang memperoleh prestasi.',
        author: 'Bagian Akademik Poliwangi',
        category: 'Prestasi',
        date: '2026-09-04',
        readCount: 148,
      ),
    ];
  }
}