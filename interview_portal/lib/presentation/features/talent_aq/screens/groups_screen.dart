import 'dart:math';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> candidates;
  const GroupsScreen({super.key, required this.candidates});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<Map<String, dynamic>> groups = [];
  List<String> tas = ['TA1', 'TA2', 'TA3'];
  List<String> statuses = ['Ongoing', 'Pending', 'Completed'];
  final Random random = Random();

  void _createGroups() {
    List<Map<String, dynamic>> shuffled = List.from(widget.candidates);
    shuffled.shuffle(random);

    List<List<Map<String, dynamic>>> tempGroups = [];
    for (int i = 0; i < shuffled.length; i += 8) {
      tempGroups.add(shuffled.sublist(i, min(i + 8, shuffled.length)));
    }

    List<Map<String, dynamic>> finalGroups = [];

    for (int i = 0; i < tempGroups.length; i++) {
      finalGroups.add({
        'groupName': 'Group ${i + 1}',
        'ta': tas[random.nextInt(tas.length)],
        'status': statuses[random.nextInt(statuses.length)], 
        'members': tempGroups[i],
      });
    }

    setState(() {
      groups = finalGroups;
    });
  }

  void _showRatingSheet(Map<String, dynamic> candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Map<String, double> ratings = {
          'Active Listening': 0,
          'Thinking': 0,
          'English': 0,
          'Speaking': 0,
          'Attitude': 0,
        };

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rate ${candidate['Name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...ratings.keys.map(
                  (criteria) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(criteria),
                      Slider(
                        value: ratings[criteria]!,
                        onChanged: (v) => setModalState(() {
                          ratings[criteria] = v;
                        }),
                        divisions: 5,
                        label: ratings[criteria]!.toStringAsFixed(1),
                        min: 0,
                        max: 5,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ratings submitted for ${candidate['Name']}',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _createGroups,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Create Random Groups'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: groups.isEmpty
                  ? const Center(
                      child: Text('No groups yet. Tap the button above.'),
                    )
                  : ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        Color statusColor;
                        switch (group['status']) {
                          case 'Completed':
                            statusColor = Colors.green;
                            break;
                          case 'Ongoing':
                            statusColor = Colors.orange;
                            break;
                          default:
                            statusColor = Colors.grey;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${group['groupName']} - ${group['ta']}"),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 6,
                                      backgroundColor: statusColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(group['status']),
                                  ],
                                ),
                              ],
                            ),
                            children: [
                              ...group['members'].map<Widget>((m) {
                                return ListTile(
                                  title: Text(m['Name']),
                                  subtitle: Text(m['Email']),
                                  trailing: group['status'] == 'Completed'
                                      ? ElevatedButton(
                                          onPressed: () => _showRatingSheet(m),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            minimumSize: const Size(60, 35),
                                          ),
                                          child: const Text("Rate"),
                                        )
                                      : null,
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
