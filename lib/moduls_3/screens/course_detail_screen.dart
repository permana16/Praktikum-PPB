import 'package:flutter/material.dart';
import '../models/krs_course.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.course});

  final KrsCourse course;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late int _sks;

  @override
  void initState() {
    super.initState();
    _sks = widget.course.sks;
  }

  Future<void> _ubahBobotSks() async {
    final int? sksBaru = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Ubah Bobot SKS'),
          children: [
            for (int sks = 1; sks <= 6; sks++)
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, sks);
                },
                child: Text('$sks SKS'),
              ),
          ],
        );
      },
    );

    if (sksBaru == null) return;

    setState(() {
      _sks = sksBaru;
    });

    if (!mounted) return;

    Navigator.pop(context, sksBaru);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.code)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.course.lecturer,
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Text(
              widget.course.description.isNotEmpty
                  ? widget.course.description
                  : 'Belum ada deskripsi silabus untuk mata kuliah ini.',
            ),
            const SizedBox(height: 32),

            Text(
              'Bobot SKS: $_sks SKS',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: _ubahBobotSks,
              icon: const Icon(Icons.edit),
              label: const Text('Ubah Bobot SKS'),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar KRS'),
            ),
          ],
        ),
      ),
    );
  }
}
