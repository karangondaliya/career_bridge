import 'package:flutter/material.dart';
import '../utils/posting_helper.dart';
import '../models/job_posting.dart';

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  final String? userName;

  const HomePage({Key? key, required this.isLoggedIn, this.userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Redirect to login page if not logged in
    if (!widget.isLoggedIn) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareerBridge'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          if (widget.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.userName != null ? widget.userName![0] : 'U',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(widget.userName ?? 'User', style: TextStyle(color: Colors.white)),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: _handleLogout,
                  ),
                ],
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
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.userName != null ? widget.userName![0] : 'U',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                      radius: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.userName ?? 'User',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              _createDrawerItem(icon: Icons.home, text: 'Home', onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              }),
              _createDrawerItem(icon: Icons.work, text: 'Jobs', onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              }),
              _createDrawerItem(icon: Icons.business, text: 'Companies', onTap: () {
                Navigator.pushNamed(context, '/companies');
              }),
              _createDrawerItem(icon: Icons.message, text: 'Messages', onTap: () {
                Navigator.pushNamed(context, '/messages');
              }),
              _createDrawerItem(icon: Icons.settings, text: 'Settings', onTap: () {
                Navigator.pushNamed(context, '/settings');
              }),
              _createDrawerItem(icon: Icons.logout, text: 'Log Out', onTap: _handleLogout),
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
                  'Welcome, ${widget.userName ?? 'User'}!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Explore the best opportunities and connect with top companies.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 24),
                _createElevatedButton(
                  text: 'Browse Jobs',
                  onPressed: () {
                    Navigator.pushNamed(context, '/jobs');
                  },
                ),
                SizedBox(height: 16),
                _createElevatedButton(
                  text: 'Explore Companies',
                  onPressed: () {
                    Navigator.pushNamed(context, '/companies');
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Latest Jobs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(height: 16),
                FutureBuilder<List<JobPosting>>(
                  future: PostingHelper().getJobPostings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No job postings available.'));
                    } else {
                      final jobs = snapshot.data!;
                      return Column(
                        children: jobs.map((job) => JobCard(
                          jobTitle: job.jobTitle,
                          company: job.requirements, // Assuming this field is used for company name
                          location: job.salary, // Assuming this field is used for location
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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: TextStyle(fontSize: 16),
        shadowColor: Colors.blueGrey[300],
        elevation: 5,
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String location;

  const JobCard({Key? key, required this.jobTitle, required this.company, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.lightBlueAccent, width: 1),
      ),
      elevation: 8,
      child: ListTile(
        leading: Icon(Icons.work, color: Colors.lightBlueAccent),
        title: Text(jobTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('$company - $location'),
        onTap: () {
          // Handle job detail navigation
        },
      ),
    );
  }
}
