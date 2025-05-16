import 'package:flutter/material.dart';

class RecentRoute extends StatelessWidget {
  final String time;
  final String from;
  final String to;


  const RecentRoute({
    super.key,
    required this.time,
    required this.from,
    required this.to
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

     return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.onSurface.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: const Icon(Icons.star_border, size: 20,),
                  onTap: () {},
                )
              ],
            ),
            const SizedBox(height: 12),
            // Route info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    children: [
                      Icon(Icons.radio_button_checked, size: 14, color: theme.secondary),
                      Container(
                        width: 2,
                        height: 24,
                        color: theme.secondary.withValues(alpha: 0.5),
                      ),
                      Icon(Icons.location_on, size: 16, color: theme.secondary),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // From/To
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        from,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        to,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}