import 'package:flutter/material.dart';
import '../models/krs_course.dart';

class AddKrsScreen extends StatefulWidget {
  const AddKrsScreen({super.key});

  @override
  State<AddKrsScreen> createState() => _AddKrsScreenState();
}

class _AddKrsScreenState extends State<AddKrsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lecturerController = TextEditingController();
  final TextEditingController _sksController = TextEditingController(text: '3');
  bool get _formSudahDiisi {
    return _codeController.text.trim().isNotEmpty ||
        _nameController.text.trim().isNotEmpty ||
        _lecturerController.text.trim().isNotEmpty;
  }

  Future<void> _konfirmasiKeluar() async {
    final bool? keluar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar dari form?'),
          content: const Text(
            'Data yang sudah diisi belum disimpan. '
            'Apakah Anda yakin ingin keluar?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Tetap di Form'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (!mounted || keluar != true) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Wajib: setiap controller harus dibebaskan agar tidak bocor memori.
    _codeController.dispose();
    _nameController.dispose();
    _lecturerController.dispose();
    _sksController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final KrsCourse courseBaru = KrsCourse(
      code: _codeController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      lecturer: _lecturerController.text.trim(),
      sks: int.tryParse(_sksController.text.trim()) ?? 3,
    );

    Navigator.pop(context, courseBaru);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<KrsCourse?>(
      canPop: !_formSudahDiisi,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _konfirmasiKeluar();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Tambah Mata Kuliah')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  hintText: 'Contoh: TRPL506',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final teks = value?.trim() ?? '';

                  if (teks.isEmpty) {
                    return 'Kode mata kuliah wajib diisi';
                  }

                  if (teks.length < 4) {
                    return 'Kode minimal terdiri dari 4 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value?.trim() ?? '').isEmpty) {
                    return 'Nama mata kuliah wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(
                  labelText: 'Dosen',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value?.trim() ?? '').isEmpty) {
                    return 'Nama dosen wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _sksController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'SKS',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final sks = int.tryParse(value?.trim() ?? '');

                  if (sks == null) {
                    return 'SKS harus berupa angka';
                  }

                  if (sks < 1 || sks > 6) {
                    return 'SKS harus antara 1 sampai 6';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... build() berisi Form dengan TextFormField dan validator
