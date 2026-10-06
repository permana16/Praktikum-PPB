import 'package:flutter/material.dart';

import 'package:tugas_362558302118_yoga_permana/moduls_4/models/announcement.dart';
import 'package:tugas_362558302118_yoga_permana/moduls_4/services/announcement_api.dart';
import 'package:tugas_362558302118_yoga_permana/moduls_4/widgets/announcement_card.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key, this.api});

  /// Dapat disuntikkan dari luar (widget test atau demo offline).
  final AnnouncementApi? api;

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  static const List<String> _kategori = <String>[
    'Semua',
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Prestasi',
  ];

  late final AnnouncementApi _api = widget.api ?? AnnouncementApi();

  late Future<List<Announcement>> _futurePengumuman;

  String _kategoriTerpilih = 'Semua';
  String _kataKunci = '';
  int _percobaan = 0;
  bool _sedangMenyegarkan = false;

  @override
  void initState() {
    super.initState();

    _futurePengumuman = _api.ambilPengumuman();
  }

  @override
  void dispose() {
    _api.tutup();
    super.dispose();
  }

  // ==========================================
  // REFRESH DATA
  // ==========================================
Future<void> _muatUlang() async {
  setState(() {
    _percobaan++;
    _sedangMenyegarkan = true;
  });

  try {
    final List<Announcement> data =
        await _api.ambilPengumuman();

    if (!mounted) return;

    setState(() {
      _futurePengumuman =
          Future<List<Announcement>>.value(data);
      _sedangMenyegarkan = false;
    });
  } catch (error) {
    if (!mounted) return;

    setState(() {
      _futurePengumuman =
          Future<List<Announcement>>.error(error);
      _sedangMenyegarkan = false;
    });
  }
}

  // ==========================================
  // PILIH KATEGORI
  // ==========================================
  void _pilihKategori(String kategori) {
    if (kategori == _kategoriTerpilih) {
      return;
    }

    setState(() {
      _kategoriTerpilih = kategori;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portal Pengumuman TRPL ($_percobaan)'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Segarkan Data',
            onPressed: _muatUlang,
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          // ==========================================
          // FILTER KATEGORI
          // ==========================================
          _buildBarisFilter(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari judul pengumuman...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  _kataKunci = value;
                });
              },
            ),
          ),

          if (_sedangMenyegarkan)
          const LinearProgressIndicator(minHeight: 3,),
          const Divider(height: 1),

          // ==========================================
          // DATA PENGUMUMAN
          // ==========================================
          Expanded(
            child: FutureBuilder<List<Announcement>>(
              future: _futurePengumuman,

              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<List<Announcement>> snapshot,
                  ) {
                    // ==========================================
                    // 1. LOADING
                    // ==========================================
                    if (snapshot.connectionState != ConnectionState.done) {
                      return _buildMemuat();
                    }

                    // ==========================================
                    // 2. ERROR
                    // ==========================================
                    if (snapshot.hasError) {
                      return _buildGagal(snapshot.error!);
                    }

                    // ==========================================
                    // DATA
                    // ==========================================
                    final List<Announcement> semua =
                        snapshot.data ?? const <Announcement>[];

                    // ==========================================
                    // FILTER KATEGORI
                    // ==========================================
                    final String kataKunci = _kataKunci.trim().toLowerCase();
                    final List<Announcement> tampil = semua.where((
                      Announcement item,
                    ) {
                      final bool cocokKategori =
                          _kategoriTerpilih == 'Semua' ||
                          item.category.toLowerCase() ==
                              _kategoriTerpilih.toLowerCase();
                      final bool cocokJudul =
                          kataKunci.isEmpty ||
                          item.title.toLowerCase().contains(kataKunci);
                      return cocokKategori && cocokJudul;
                    }).toList();
                    _kategoriTerpilih == 'Semua'
                        ? semua
                        : semua
                              .where(
                                (Announcement item) =>
                                    item.category.toLowerCase() ==
                                    _kategoriTerpilih.toLowerCase(),
                              )
                              .toList(growable: false);

                    // ==========================================
                    // 3. KOSONG
                    // ==========================================
                    if (tampil.isEmpty) {
                      return _buildKosong();
                    }

                    // ==========================================
                    // 4. BERHASIL
                    // ==========================================
                    return _buildDaftar(tampil);
                  },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FILTER KATEGORI
  // ==========================================
  Widget _buildBarisFilter() {
    return SizedBox(
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: _kategori.map((String kategori) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(kategori),
              selected: kategori == _kategoriTerpilih,
              onSelected: (_) {
                _pilihKategori(kategori);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // LOADING
  // ==========================================
  Widget _buildMemuat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),

          SizedBox(height: 16),

          Text('Memuat pengumuman...'),
        ],
      ),
    );
  }

  // ==========================================
  // ERROR
  // ==========================================
  Widget _buildGagal(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.cloud_off, size: 64),

            const SizedBox(height: 16),

            const Text(
              'Gagal memuat pengumuman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(error.toString(), textAlign: TextAlign.center),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _muatUlang,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // DATA KOSONG
  // ==========================================
  Widget _buildKosong() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.inbox_outlined, size: 64),

            const SizedBox(height: 16),

            Text(
              _kategoriTerpilih == 'Semua'
                  ? 'Belum ada pengumuman.'
                  : 'Tidak ada pengumuman '
                        'untuk kategori '
                        '$_kategoriTerpilih.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // DAFTAR PENGUMUMAN
  // ==========================================
  Widget _buildDaftar(List<Announcement> items) {
    return RefreshIndicator(
      onRefresh: _muatUlang,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final Announcement item = items[index];

          return AnnouncementCard(
            announcement: item,
            onTap: () {
              // Tidak menggunakan halaman detail.
            },
          );
        },
      ),
    );
  }
}
