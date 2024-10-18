import 'dart:typed_data'; // Add this for Uint8List
import 'package:flutter/material.dart';
import '../utils/posting_helper.dart';
import '../models/job_posting.dart';
import '../screens/feedback_dialog.dart';
import '../models/job_card.dart';
import '../models/user_profile_image.dart'; // Ensure you have this model
import '../utils/profile_image_helper.dart'; // Ensure you have this helper
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  final String? userEmail;

  const HomePage({Key? key, required this.isLoggedIn, this.userEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _profileImageData; // Define the profile image data variable
  List<JobPosting> _allJobs = []; // Store all job postings
  List<JobPosting> _filteredJobs = []; // Store filtered jobs
  String _searchQuery = ''; // Keep track of the search query

  @override
  void initState() {
    super.initState();
    if (!widget.isLoggedIn) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    _fetchProfileImage(); // Fetch the profile image on init
    _fetchJobs(); // Fetch all jobs when the HomePage is initialized
  }

  Future<void> _fetchJobs() async {
    _allJobs = await PostingHelper().getJobPostings(); // Fetch all job postings
    setState(() {
      _filteredJobs = _allJobs; // Initially, all jobs are filtered
    });
  }

  Future<void> _fetchProfileImage() async {
    if (widget.userEmail != null) {
      UserProfileImage? profileImage = await ProfileImageHelper.instance.getProfileImageByEmail(widget.userEmail!);
      setState(() {
        _profileImageData = profileImage?.imageData;
      });
    }
  }

  void _filterJobs(String query) {
    setState(() {
      _searchQuery = query.toLowerCase(); // Convert the query to lowercase
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

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile', arguments: {'email': widget.userEmail});
  }

  Future<void> _launchURL() async {
    const url = 'https://www.myperfectresume.com/resume/ats-resume-checker';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  void _openFeedbackDialog() {
    FeedbackDialog.showFeedbackDialog(context, widget.userEmail ?? ''); // Pass the user email
  }


  // Highlight matching text in the job title
  Widget _highlightText(String text) {
    final textParts = text.split(RegExp('(${RegExp.escape(_searchQuery)})', caseSensitive: false));
    return RichText(
      text: TextSpan(
        children: textParts.map((part) {
          if (part.toLowerCase() == _searchQuery.toLowerCase()) {
            return TextSpan(text: part, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent));
          }
          return TextSpan(text: part, style: const TextStyle(color: Colors.black));
        }).toList(),
      ),
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
                      backgroundImage: _profileImageData != null ? MemoryImage(_profileImageData!) : null,
                      child: _profileImageData == null
                          ? Text(displayedUserEmail[0].toUpperCase(), style: const TextStyle(color: Colors.lightBlueAccent))
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(displayedUserEmail, style: const TextStyle(color: Colors.white)),
                    IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
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
                decoration: const BoxDecoration(color: Colors.lightBlueAccent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _navigateToProfile,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImageData != null ? MemoryImage(_profileImageData!) : null,
                        radius: 30,
                        child: _profileImageData == null
                            ? Text(widget.userEmail != null ? widget.userEmail![0] : 'U', style: const TextStyle(color: Colors.lightBlueAccent))
                            : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: InkWell(
                        onTap: _navigateToProfile,
                        child: Text(widget.userEmail ?? 'User', style: const TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ),
              _createDrawerItem(icon: Icons.home, text: 'Home', onTap: () async {
                await _fetchProfileImage(); // Call the function to fetch the profile image

              }),
              _createDrawerItem(icon: Icons.business, text: 'Skill Test', onTap: () {
                Navigator.pushNamed(context, '/skill_test');
              }),
              _createDrawerItem(icon: Icons.message, text: 'Notification', onTap: () {
                Navigator.pushNamed(context, '/message_view', arguments: widget.userEmail ?? '');
              }),
              _createDrawerItem(icon: Icons.feedback, text: 'Feedback', onTap: _openFeedbackDialog),
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
                  'Welcome, ${widget.userEmail ?? 'User'}!',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
                ),
                const SizedBox(height: 16),
                const Text('Explore the best opportunities and connect with top companies.', style: TextStyle(fontSize: 18, color: Colors.black54)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _launchURL,
                  child: Text('ATS Resume Scanner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: const TextStyle(fontSize: 16),
                    shadowColor: Colors.blueGrey[300],
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 20),
                // Search bar implementation
                TextField(
                  onChanged: _filterJobs, // Call filter function on change
                  decoration: InputDecoration(
                    hintText: 'Search for jobs...',
                    prefixIcon: const Icon(Icons.search, color: Colors.lightBlueAccent),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Display matched job postings only if the search query is not empty
                if (_searchQuery.isNotEmpty) ...[
                  if (_filteredJobs.isNotEmpty) ...[
                    const Text('Matched Jobs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = _filteredJobs[index];
                        return JobCard(
                          jobTitle: job.jobTitle, // Highlight the matched text
                          company: job.providerEmail,
                          location: 'N/A',
                          jobDescription: job.jobDescription,
                          requirements: job.requirements,
                          salary: job.salary,
                          datePosted: job.datePosted,
                          providerEmail: job.providerEmail,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    // Message when no jobs match the search query
                    const SizedBox(height: 1),
                    Center( // Wrap the Text widget with Center
                      child: const Text(
                        'No results found for your search.',
                        style: TextStyle(fontSize: 24, color: Colors.indigoAccent),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ],
                // Latest Jobs section
                const Text('Latest Jobs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                const SizedBox(height: 16),
                FutureBuilder<List<JobPosting>>(
                  future: PostingHelper().getJobPostings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final latestJobs = snapshot.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: latestJobs.length,
                        itemBuilder: (context, index) {
                          final job = latestJobs[index];
                          return JobCard(
                            jobTitle: job.jobTitle,
                            company: job.providerEmail,
                            location: 'N/A',
                            jobDescription: job.jobDescription,
                            requirements: job.requirements,
                            salary: job.salary,
                            datePosted: job.datePosted,
                            providerEmail: job.providerEmail,
                          );
                        },
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

  Widget _createDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightBlueAccent),
      title: Text(text),
      onTap: onTap,
    );
  }
}
