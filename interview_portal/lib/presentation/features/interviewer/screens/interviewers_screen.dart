import 'package:flutter/material.dart';

class InterviewerHomeScreen extends StatelessWidget {
  const InterviewerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interviewer Dashboard'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _OverviewCard(title: 'Total Interviews', value: '6'),
                _OverviewCard(title: 'Completed', value: '3'),
                _OverviewCard(title: 'Pending', value: '3'),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Upcoming Interviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            
            _InterviewCard(
              name: 'Priya Sharma',
              stage: 'GD',
              time: '10:00 AM',
              status: 'Pending',
            ),
            _InterviewCard(
              name: 'Raj Verma',
              stage: 'L1',
              time: '11:30 AM',
              status: 'Ongoing',
            ),
            _InterviewCard(
              name: 'Sneha Patel',
              stage: 'L2',
              time: '2:00 PM',
              status: 'Completed',
            ),

            const SizedBox(height: 20),

            const Text(
              'Past Interviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            _PastInterviewCard(
              name: 'Amit Deshmukh',
              stage: 'Fit Round',
              result: 'Selected',
            ),
            _PastInterviewCard(
              name: 'Neha Singh',
              stage: 'GD',
              result: 'Rejected',
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;

  const _OverviewCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final String name;
  final String stage;
  final String time;
  final String status;

  const _InterviewCard({required this.name, required this.stage, required this.time, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(name[0])),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Stage: $stage\nTime: $time'),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: status == 'Completed' ? Colors.green : Colors.blue,
          ),
          child: Text(status == 'Pending'
              ? 'Start'
              : status == 'Ongoing'
                  ? 'Continue'
                  : 'View'),
        ),
      ),
    );
  }
}

class _PastInterviewCard extends StatelessWidget {
  final String name;
  final String stage;
  final String result;

  const _PastInterviewCard({required this.name, required this.stage, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.history, color: Colors.grey),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('Stage: $stage'),
        trailing: Text(
          result,
          style: TextStyle(
            color: result == 'Selected' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}