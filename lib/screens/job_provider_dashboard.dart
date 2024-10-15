import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:career_bridge/screens/user_profile_page.dart';
import '../models/job_posting.dart';
import '../utils/posting_helper.dart';
import 'create_job_posting_form.dart';
import 'job_provider/job_applications_page.dart';
import '../screens/feedback_dialog.dart';
import '../models/user_profile_image.dart'; // Import your UserProfileImage model
import '../utils/profile_image_helper.dart';
import 'login_page.dart'; // Import your ProfileImageHelper

class JobProviderDashboard extends StatefulWidget {
  final String providerEmail; // Accept provider email as a parameter

  JobProviderDashboard({required this.providerEmail}); // Pass this in the constructor

  @override
  _JobProviderDashboardState createState() => _JobProviderDashboardState();
}

class _JobProviderDashboardState extends State<JobProviderDashboard> {
  Uint8List? _profileImageData; // Variable to hold profile image data
  List<JobPosting> _allJobs = []; // Store all jobs
  List<JobPosting> _filteredJobs = []; // Store filtered jobs based on search
  String _searchQuery = ''; // Search query

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
    _fetchJobs(); // Fetch jobs for the provider when dashboard initializes
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _fetchProfileImage() async {
    // Fetch the profile image from the database
    if (widget.providerEmail.isNotEmpty) {
      UserProfileImage? profileImage = await ProfileImageHelper.instance.getProfileImageByEmail(widget.providerEmail);
      setState(() {
        _profileImageData = profileImage?.imageData; // Update state with the image data
      });
    }
  }

  Future<void> _fetchJobs() async {
    // Fetch jobs for the logged-in job provider
    _allJobs = await PostingHelper().getJobPostingsByProvider(widget.providerEmail);
    setState(() {
      _filteredJobs = _allJobs; // Initially, show all jobs
    });
  }

  void _filterJobs(String query) {
    setState(() {
      _searchQuery = query.toLowerCase(); // Convert the query to lowercase for case-insensitive search
      _filteredJobs = _allJobs.where((job) {
        // Check if any field contains the search query
        return job.jobTitle.toLowerCase().contains(_searchQuery) ||
            job.jobDescription.toLowerCase().contains(_searchQuery) ||
            job.requirements.toLowerCase().contains(_searchQuery) ||
            job.salary.toLowerCase().contains(_searchQuery) ||
            job.datePosted.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _openFeedbackDialog(BuildContext context) {
    FeedbackDialog.showFeedbackDialog(context, widget.providerEmail); // Use providerEmail
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Provider Dashboard'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildSidebar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.providerEmail}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            TextField(
              onChanged: _filterJobs, // Call filter function on change
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Show search results only when there is a search query
            if (_searchQuery.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Results:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Display filtered job postings
                  _filteredJobs.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = _filteredJobs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(job.jobTitle),
                          subtitle: Text('Posted on: ${job.datePosted}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to the job posting form for editing
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreateJobPostingForm(
                                        job: job,
                                        providerEmail: widget.providerEmail, // Pass the provider email
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await PostingHelper().deleteJobPosting(job.id!);
                                  // Refresh the UI by re-triggering FutureBuilder
                                  await _fetchJobs(); // Refresh the jobs after deleting
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : Text(
                    'No results found for your search.',
                    style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Recent Job Postings section
            Text(
              'Recent Job Postings:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Show original job postings as they are
            Expanded(
              child: _allJobs.isNotEmpty
                  ? ListView.builder(
                itemCount: _allJobs.length,
                itemBuilder: (context, index) {
                  final job = _allJobs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(job.jobTitle),
                      subtitle: Text('Posted on: ${job.datePosted}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Navigate to the job posting form for editing
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateJobPostingForm(
                                    job: job,
                                    providerEmail: widget.providerEmail, // Pass the provider email
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await PostingHelper().deleteJobPosting(job.id!);
                              // Refresh the UI by re-triggering FutureBuilder
                              await _fetchJobs(); // Refresh the jobs after deleting
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No job postings available.',
                  style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateJobPostingForm(providerEmail: widget.providerEmail), // Pass the provider email when creating a post
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Drawer _buildSidebar(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfilePage(email: widget.providerEmail), // Navigate to profile page
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImageData != null
                        ? MemoryImage(_profileImageData!) // Use MemoryImage if data is available
                        : AssetImage('assets/profile_picture.png') as ImageProvider, // Default image
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.providerEmail, // Show provider's email
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () async {
              await _fetchProfileImage(); // Fetch the profile image first

            },
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('Job Applications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobApplicationsPage(providerEmail: widget.providerEmail),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('Post a Job'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateJobPostingForm(providerEmail: widget.providerEmail)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              _openFeedbackDialog(context); // Pass context to the method
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: _logout, // Call the _logout function directly
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
