import 'package:flutter/material.dart';

import '../models/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.announcement, required Null Function() onTap,
  });

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna =
        Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: warna.primaryContainer,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    announcement.category,
                    style: TextStyle(
                      color:
                          warna.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  announcement.date,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              announcement.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              announcement.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    announcement.author,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.visibility_outlined,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text('${announcement.readCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}