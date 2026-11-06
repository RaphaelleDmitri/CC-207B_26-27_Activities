import 'package:flutter/material.dart';

import '../../models/profile_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> hobbies = [
    'Writing',
    'Chess',
    'Coding',
    'Reading',
    'Learning new technologies',
  ];

  static const List<ClassSlot> schedule = [
    ClassSlot(day: 'Monday', time: '9:00–12:00 PM', subject: 'CIT 251: Cyber Security'),
    ClassSlot(day: 'Tuesday', time: '7:00–9:00 AM', subject: 'CIT 210: Web Systems'),
    ClassSlot(day: 'Wednesday', time: '10:00–12:00 PM', subject: 'CIT 251: Cyber Security'),
    ClassSlot(day: 'Thursday', time: '7:00–10:00 AM', subject: 'CIT 210: Web Systems'),   
  ];

  static const List<ProfileInfo> infos = [
    ProfileInfo(
      icon: Icons.school,
      label: 'Course',
      value: 'BS Information Technology',
    ),
    ProfileInfo(
      icon: Icons.location_on,
      label: 'Location',
      value: 'Iloilo, Philippines',
    ),
    ProfileInfo(
      icon: Icons.edit,
      label: 'Role',
      value: 'Student, Literary Editor, Chess Player, and Developer',
    ),
    ProfileInfo(
      icon: Icons.computer,
      label: 'Interests',
      value: 'Chess Theories, Programming, and Writing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raphaelle Dmitri F. Alabanzas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    semanticLabel:
                        'Photo of Raphaelle Dmitri F. Alabanzas',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Raphaelle Dmitri F. Alabanzas',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A BSIT Student and a Jack of All Trades.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'About Me',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final info in infos) InfoTile(info: info),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Hobbies', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final hobby in hobbies) Chip(label: Text(hobby)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Class Schedule', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 64,
                        child: Table(
                          border: TableBorder.all(color: theme.colorScheme.outlineVariant),
                          columnWidths: const {
                            0: FixedColumnWidth(82),
                            1: FixedColumnWidth(112),
                            2: FlexColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer),
                              children: [
                                for (final heading in ['Day', 'Time', 'Subject'])
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(heading, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                            for (final slot in schedule)
                              TableRow(children: [
                                for (final value in [slot.day, slot.time, slot.subject])
                                  Padding(padding: const EdgeInsets.all(8), child: Text(value)),
                              ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Biography',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'I am an Information Technology student who enjoys '
                      'combining technology with creativity. I love writing '
                      'stories, exploring new ideas, and developing projects '
                      'that allow me to learn and express myself. I hope to '
                      'continue improving my skills as both a developer '
                      'and a writer.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassSlot {
  final String day;
  final String time;
  final String subject;

  const ClassSlot({required this.day, required this.time, required this.subject});
}
