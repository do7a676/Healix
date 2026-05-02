import 'package:flutter/material.dart';
import 'schedule_appointment_page.dart';
import '../utils/page_transitions.dart';
import '../widgets/healix_app_bar.dart';
import '../widgets/healix_background.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({super.key});

  @override
  State<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Sarah Chen',
      'specialty': 'Cardiologist',
      'rating': '4.9',
      'reviews': '124',
      'icon': Icons.favorite,
      'iconBg': const Color(0xFFFDF2F2),
    },
    {
      'name': 'Dr. Marcus Thompson',
      'specialty': 'Neurologist',
      'rating': '4.8',
      'reviews': '98',
      'icon': Icons.psychology,
      'iconBg': const Color(0xFFF0FDF4),
    },
    {
      'name': 'Dr. Elena Rodriguez',
      'specialty': 'Dermatologist',
      'rating': '4.7',
      'reviews': '156',
      'icon': Icons.face,
      'iconBg': const Color(0xFFFFF7ED),
    },
    {
      'name': 'Dr. James Wilson',
      'specialty': 'Orthopedic',
      'rating': '4.9',
      'reviews': '210',
      'icon': Icons.medical_services,
      'iconBg': const Color(0xFFF5F3FF),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredDoctors = _doctors.where((doc) => 
      doc['name'].toLowerCase().contains(_searchQuery.toLowerCase()) || 
      doc['specialty'].toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: const HealixAppBar(),
      body: HealixBackground(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Your Specialist',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Browse through our verified medical experts.',
                  style: TextStyle(color: isDark ? Colors.white54 : const Color(0xFF64748B), fontSize: 14),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search for doctors, specialties...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF00AACD)),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doc = filteredDoctors[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: _buildDoctorCard(context, doc, isDark),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map<String, dynamic> doc, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : doc['iconBg'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(doc['icon'], color: isDark ? const Color(0xFF00AACD) : const Color(0xFF0F172A), size: 35),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doc['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFFFB800), size: 16),
                            const SizedBox(width: 4),
                            Text(doc['rating'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.white70 : Colors.black)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc['specialty'],
                      style: TextStyle(color: isDark ? Colors.white54 : const Color(0xFF64748B), fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 14, color: isDark ? Colors.white38 : Colors.grey),
                        const SizedBox(width: 4),
                        Text('${doc['reviews']} Reviews', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, SlideRightRoute(page: ScheduleAppointmentPage(doctorName: doc['name'])));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AACD),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
