
import 'package:flutter/material.dart';

import '../../models/profile_info.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.info,
  });

  final ProfileInfo info;

  static const Color _ink = Color(0xFF292832);
  static const Color _muted = Color(0xFF777581);
  static const Color _accent = Color(0xFF8070B5);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EEF8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              info.icon,
              color: _accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  info.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
