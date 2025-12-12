import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview_portal/presentation/features/talent_aq/provider/candidate_provider.dart';

class ViewCandidatesScreen extends ConsumerStatefulWidget {
  const ViewCandidatesScreen({super.key});

  @override
  ConsumerState<ViewCandidatesScreen> createState() => _ViewCandidatesScreenState();
}

class _ViewCandidatesScreenState extends ConsumerState<ViewCandidatesScreen> {
  List<dynamic> candidates = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    try {
      final useCase = ref.read(getCandidatesUseCaseProvider);
      final result = await useCase.call();
      setState(() {
        candidates = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate List'),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : candidates.isEmpty
                  ? const Center(child: Text('No candidates found'))
                  : RefreshIndicator(
                      onRefresh: fetchCandidates,
                      child: ListView.builder(
                        itemCount: candidates.length,
                        itemBuilder: (context, index) {
                          final candidate = candidates[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo.shade100,
                                child: Text('${index + 1}'),
                              ),
                              title: Text(candidate['name'] ?? 'No Name'),
                              subtitle: Text(
                                'Email: ${candidate['email'] ?? 'N/A'}\n'
                                'Education: ${candidate['education'] ?? 'N/A'}\n'
                                'Stage: ${candidate['stage'] ?? 'N/A'}\n'
                                'Result: ${candidate['result'] ?? 'N/A'}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
