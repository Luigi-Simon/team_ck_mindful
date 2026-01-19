import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindful',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}

// ==========================================
// 1. SPLASH SCREEN
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 280, 
              height: 280,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.psychology, size: 280, color: Colors.grey);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Mindful",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. LOGIN PAGE (Modified to Bypass WebView)
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  // ✅ Modified: Skipping the WebView and going straight to success
  void _startLogin() {
    _fakeLoginSuccess();
  }

  void _fakeLoginSuccess() async {
    setState(() => _isLoading = true);
    // Simulate a brief check
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthenticatedHome(nric: "S8912345A"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.deepPurple)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 160,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.psychology, size: 160, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text("Mindful", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 50),
                  
                  ElevatedButton.icon(
                    onPressed: _startLogin,
                    icon: const Icon(Icons.login),
                    label: const Text("Login with Singpass"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ==========================================
// 3. FULL STAFF DASHBOARD
// ==========================================
class AuthenticatedHome extends StatelessWidget {
  final String nric;
  const AuthenticatedHome({super.key, required this.nric});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildTabs(),
                const SizedBox(height: 24),
                _buildSearchAndCreate(),
                const SizedBox(height: 32),
                _buildEventCard(),
                const SizedBox(height: 32),
                const Text(
                  "Sessions (2)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const SessionCard(
                  date: "1/25/2026",
                  time: "05:00 PM - 08:00 PM",
                  volunteers: 0,
                  participants: 0,
                ),
                const SizedBox(height: 12),
                const SessionCard(
                  date: "1/25/2026",
                  time: "09:00 PM - 12:00 AM",
                  volunteers: 0,
                  participants: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Staff Dashboard",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              "Welcome, Admin ($nric)",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabItem("Events & Sessions", isSelected: true),
          _buildTabItem("Volunteers"),
          _buildTabItem("Participants"),
          _buildTabItem("Analytics"),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: isSelected ? const Border(bottom: BorderSide(color: Colors.red, width: 3)) : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.red : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSearchAndCreate() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(14),
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildEventCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Community Cleanup",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "📍 East Coast Park | 10:00 AM",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final String date;
  final String time;
  final int volunteers;
  final int participants;

  const SessionCard({super.key, required this.date, required this.time, required this.volunteers, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text("$date • $time", style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.circle, size: 10, color: Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("Volunteers: $volunteers"),
                const SizedBox(width: 20),
                Text("Participants: $participants"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}