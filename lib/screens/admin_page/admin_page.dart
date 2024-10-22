import 'package:flutter/material.dart';
import '../login_page.dart';
import '../../models/feedback.dart';
import '../../utils/feedback_helper.dart';
import '../../models/user.dart';
import '../../utils/database_helper.dart';
import '../../models/job_posting.dart';
import '../../utils/posting_helper.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<UserFeedback>> _feedbackList;
  late Future<List<User>> _userList;
  late Future<List<JobPosting>> _jobPostingList;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _feedbackList = FeedbackHelper().getFeedbacks();
    _userList = _fetchUsers();
    _jobPostingList = PostingHelper().getJobPostings();
  }

  Future<List<User>> _fetchUsers() async {
    List<User> users = await _databaseHelper.getAllUsers();
    return users;
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _refreshData() {
    setState(() {
      _fetchData();
    });
  }

  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(
        5,
            (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow[700],
          size: 28,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle(_selectedIndex),
            if (_selectedIndex == 0) _buildFeedbackList(),
            if (_selectedIndex == 1) _buildUserList(),
            if (_selectedIndex == 2) _buildJobPostingList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Job Postings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlueAccent,
      ),
    );
  }

  Widget _buildSectionTitle(int index) {
    String title;
    switch (index) {
      case 0:
        title = 'Feedback';
        break;
      case 1:
        title = 'Users';
        break;
      case 2:
        title = 'Job Postings';
        break;
      default:
        title = '';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFeedbackList() {
    return FutureBuilder<List<UserFeedback>>(
      future: _feedbackList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState('No feedback available.');
        } else {
          final feedbacks = snapshot.data!;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.5, // Adjust based on design preference
            ),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              return _buildFeedbackCard(feedback);
            },
          );
        }
      },
    );
  }

  Widget _buildFeedbackCard(UserFeedback feedback) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 10, // Increased elevation for better shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.lightBlueAccent.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rating:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                _buildStarRating(feedback.rating),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Suggestions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feedback.suggestions,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'User: ${feedback.userEmail}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return FutureBuilder<List<User>>(
      future: _userList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState('No users available.');
        } else {
          final users = snapshot.data!;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserCard(user);
            },
          );
        }
      },
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.lightBlueAccent.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Role: ${user.role}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildJobPostingList() {
    return FutureBuilder<List<JobPosting>>(
      future: _jobPostingList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingPlaceholder();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState('No job postings available.');
        } else {
          final jobPostings = snapshot.data!;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: jobPostings.length,
            itemBuilder: (context, index) {
              final jobPosting = jobPostings[index];
              return _buildJobPostingItem(jobPosting);
            },
          );
        }
      },
    );
  }

  Widget _buildJobPostingItem(JobPosting posting) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlueAccent.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            posting.jobTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            posting.jobDescription,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Requirements: ${posting.requirements}',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Salary: ${posting.salary}',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Posted on: ${posting.datePosted}\nProvider: ${posting.providerEmail}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLoadingPlaceholder() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }
}
