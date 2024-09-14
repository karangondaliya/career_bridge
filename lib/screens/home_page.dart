
import 'package:flutter/material.dart';
import '../utils/posting_helper.dart';
import '../models/job_posting.dart';
import '../models/job_detail_dialog.dart';
import '../models/job_card.dart';

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  final String? userEmail;

  const HomePage({Key? key, required this.isLoggedIn, this.userEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (!widget.isLoggedIn) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToProfile() {
    Navigator.pushNamed(
      context,
      '/profile',
      arguments: {
        'email': widget.userEmail,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayedUserEmail = widget.userEmail ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareerBridge'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          if (widget.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: _navigateToProfile,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        displayedUserEmail[0].toUpperCase(),
                        style: const TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(displayedUserEmail, style: const TextStyle(color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _handleLogout,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _navigateToProfile,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          widget.userEmail != null ? widget.userEmail![0] : 'U',
                          style: const TextStyle(color: Colors.lightBlueAccent),
                        ),
                        radius: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: _navigateToProfile,
                        child: Text(
                          widget.userEmail ?? 'User',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _createDrawerItem(
                  icon: Icons.home,
                  text: 'Home',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  }),
              _createDrawerItem(
                  icon: Icons.work,
                  text: 'Jobs',
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  }),
              _createDrawerItem(
                  icon: Icons.business,
                  text: 'Companies',
                  onTap: () {
                    Navigator.pushNamed(context, '/companies');
                  }),
              _createDrawerItem(
                  icon: Icons.message,
                  text: 'Messages',
                  onTap: () {
                    Navigator.pushNamed(context, '/messages');
                  }),
              _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  }),
              _createDrawerItem(
                  icon: Icons.logout, text: 'Log Out', onTap: _handleLogout),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${widget.userEmail ?? 'User'}!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explore the best opportunities and connect with top companies.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                _createElevatedButton(
                  text: 'Browse Jobs',
                  onPressed: () {
                    Navigator.pushNamed(context, '/jobs');
                  },
                ),
                const SizedBox(height: 16),
                _createElevatedButton(
                  text: 'Explore Companies',
                  onPressed: () {
                    Navigator.pushNamed(context, '/companies');
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Latest Jobs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<JobPosting>>(
                  future: PostingHelper().getJobPostings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No job postings available.'));
                    } else {
                      final jobs = snapshot.data!;
                      return Column(
                        children: jobs.map((job) => JobCard(
                          jobTitle: job.jobTitle,
                          company: job.requirements, // Assuming this field is used for company name
                          location: job.salary, // Assuming this field is used for location
                          jobDescription: job.jobDescription,
                          requirements: job.requirements,
                          salary: job.salary,
                          datePosted: job.datePosted,
                          providerEmail: job.providerEmail,
                        )).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile _createDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlueAccent),
      title: Text(text),
      onTap: onTap,
    );
  }

  ElevatedButton _createElevatedButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16),
        shadowColor: Colors.blueGrey[300],
        elevation: 5,
      ),
    );
  }
}
