import 'package:flutter/material.dart';
import '../widgets/healix_app_bar.dart';
import 'doctors_list_page.dart';
import 'ai_agent_page.dart';
import 'history_page.dart';
import 'vitals_page.dart';
import '../store/healix_store.dart';
import '../utils/page_transitions.dart';
import '../widgets/healix_background.dart';

class DashboardPage extends StatelessWidget {
  final String username;
  const DashboardPage({super.key, this.username = 'Alex'});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const HealixAppBar(),
      body: HealixBackground(
        child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: healixStore.userName,
                builder: (context, name, _) => _buildWelcomeSection(name),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Upcoming Appointment', 'View All', isDark, () {
                Navigator.push(context, SlideRightRoute(page: const DoctorsListPage()));
              }),
            const SizedBox(height: 12),
            ValueListenableBuilder<Map<String, dynamic>?>(
              valueListenable: healixStore.lastAppointment,
              builder: (context, appointment, child) {
                if (appointment != null) {
                  return _buildUpcomingAppointment(context, 
                    doctorName: appointment['doctorName'],
                    date: appointment['date'],
                    time: appointment['time'],
                  );
                }
                return _buildUpcomingAppointment(context);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Recent Analysis', 'Full History', isDark, () {
              Navigator.push(context, SlideRightRoute(page: const HistoryPage()));
            }),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: healixStore.historyRecords,
              builder: (context, records, _) {
                if (records.isNotEmpty) {
                  return _buildRecentAnalysis(context, record: records.first);
                }
                return const Center(child: Text('No recent analysis'));
              },
            ),
            const SizedBox(height: 24),
            _buildHealthPulseBanner(context),
            const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, bool isDark, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(
            actionText,
            style: const TextStyle(color: Color(0xFF00AACD), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, $name',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Here is your health overview for today.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingAppointment(BuildContext context, {String? doctorName, String? date, String? time}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_box_outlined, color: Color(0xFF0088CC), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName ?? 'Dr. Sarah Chen',
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cardiology Consultation',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.calendar_month_outlined, color: const Color(0xFF64748B).withOpacity(0.2), size: 64),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildAppointmentInfo(Icons.calendar_today_outlined, date ?? 'Oct 24, 2023'),
              const SizedBox(width: 20),
              _buildAppointmentInfo(Icons.access_time, time ?? '09:30 AM'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Check-in successful! Please wait to be called.'),
                      ],
                    ),
                    backgroundColor: const Color(0xFF00AACD),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006677),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text('Check In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0088CC), size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRecentAnalysis(BuildContext context, {Map<String, dynamic>? record}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.water_drop_outlined, color: Color(0xFFB91C1C), size: 24),
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
                          record?['title'] ?? 'Blood Glucose Analysis',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(record?['date'] ?? 'Oct 12', style: TextStyle(color: const Color(0xFF64748B).withOpacity(0.6), fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, color: Color(0xFF166534), size: 14),
                          SizedBox(width: 4),
                          Text(
                            'PROCESSED',
                            style: TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: const Border(left: BorderSide(color: Color(0xFF0088CC), width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.smart_toy_outlined, color: Color(0xFF0088CC), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Healix AI Summary',
                      style: TextStyle(color: Color(0xFF0088CC), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\"Your latest blood glucose levels are within the optimal range. No significant fluctuations detected. Dr. Chen will discuss the full report during your appointment.\"',
                  style: TextStyle(color: const Color(0xFF0F172A).withOpacity(0.8), fontSize: 14, fontStyle: FontStyle.italic, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AiAgentPage()));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(color: const Color(0xFF0F172A).withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: const Color(0xFF0F172A).withOpacity(0.7), size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthPulseBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, SlideRightRoute(page: const VitalsPage()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0088CC), Color(0xFF006688)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Healix Health Pulse',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your vitals are looking optimal today.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(Icons.bar_chart, color: Colors.white.withOpacity(0.2), size: 60),
            ),
          ],
        ),
      ),
    );
  }
}
