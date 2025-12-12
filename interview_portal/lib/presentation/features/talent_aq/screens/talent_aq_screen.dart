import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:interview_portal/core/shared_prefs/shared_prefs.dart';
import 'package:interview_portal/presentation/features/talent_aq/screens/create_candidate.dart';
import 'package:interview_portal/presentation/features/talent_aq/screens/view_candidates_screen';
import 'groups_screen.dart';

class TalentAqScreen extends StatefulWidget {
  const TalentAqScreen({super.key});

  @override
  State<TalentAqScreen> createState() => _TalentAqScreenState();
}

class _TalentAqScreenState extends State<TalentAqScreen> {
  List<Map<String, dynamic>> candidates = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    setState(() => isLoading = true);
    try {
      final token = await SharedPrefs.getToken();
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please login again.")));
        return;
      }

      final dio = Dio();
      final response = await dio.get(
        'https://herschel-hyperneurotic-hilma.ngrok-free.dev/TA/view',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          candidates = List<Map<String, dynamic>>.from(
            data['candidates'] ?? data,
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching candidates: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void viewCandidates() {
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No candidates found.")));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewCandidatesScreen(candidates: candidates),
      ),
    );
  }

  void viewGroups() {
    if (candidates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload candidates first.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupsScreen(candidates: candidates),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'View Candidates',
        'icon': Icons.people_alt,
        'color': Colors.blue,
        'onTap': viewCandidates,
      },
      {
        'title': 'Create Candidate',
        'icon': Icons.person_add,
        'color': Colors.green,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCandidateScreen(),
            ),
          ).then((_) => fetchCandidates()); // refresh after creating new one
        },
      },
      {
        'title': 'Groups',
        'icon': Icons.group_work,
        'color': Colors.orange,
        'onTap': viewGroups,
      },
      {
        'title': 'Evaluation',
        'icon': Icons.assessment,
        'color': Colors.purple,
        'onTap': () {},
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: item['onTap'],
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], color: item['color'], size: 48),
                          const SizedBox(height: 12),
                          Text(
                            item['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: item['color'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
