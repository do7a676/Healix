import 'package:flutter/material.dart';
import 'patient_record_detail_page.dart';

class DoctorSchedulePage extends StatelessWidget {
  const DoctorSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF00C4D4)),
          onPressed: () {},
        ),
        title: const Text(
          'Healix',
          style: TextStyle(
            color: Color(0xFF00C4D4),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF334155)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Schedule',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'You have 8 consultations scheduled for today.',
              style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade400),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.filter_list, size: 16, color: Color(0xFF0F172A)),
                      SizedBox(width: 8),
                      Text('Filter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C4D4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text('New Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCalendarStrip(),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 24),
            _buildDivider('UPCOMING TODAY'),
            const SizedBox(height: 16),
            _upcomingItem(context, '09:30', 'AM', 'Alexander Thompson', 'Routine Check-up • 30 mins', 'confirmed'),
            _upcomingItem(context, '10:15', 'AM', 'Sarah Mitchell', 'Initial Consultation • 45 mins', 'pending'),
            _upcomingItem(context, '11:30', 'AM', 'Gregory House', 'Diagnostic Review • 60 mins', 'confirmed'),
            const SizedBox(height: 8),
            _buildDivider('PAST CONSULTATIONS'),
            const SizedBox(height: 16),
            _pastItem(context, '08:00\nAM', 'Elena Rodriguez', 'Follow-up Lab Results • 15 mins'),
            _pastItem(context, 'Yesterday\n04:30 PM', 'Marcus Chen', 'Prescription Renewal • 15 mins'),
            const SizedBox(height: 24),
            _buildAiInsightsCard(),
            const SizedBox(height: 80), // Padding for BottomNav
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 2));
          final isToday = index == 2;
          return Container(
            width: 65,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isToday ? const Color(0xFF007580) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][date.weekday % 7],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white70 : Colors.blueGrey.shade300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isToday ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statCard('COMPLETED', '124', const Color(0xFF007580), 0.6)),
            const SizedBox(width: 16),
            Expanded(child: _statCard('CONFIRMED', '08', const Color(0xFF007580), 0.3)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _statCard('PENDING', '03', Colors.orange, 0.2)),
            const SizedBox(width: 16),
            Expanded(child: _statCard('EFFICIENCY', '94%', Colors.black87, 0.94)),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade400, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 12),
          Container(
            height: 3,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(String text) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade400, letterSpacing: 0.5)),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
      ],
    );
  }

  Widget _upcomingItem(BuildContext context, String time, String period, String name, String details, String status) {
    final isConfirmed = status == 'confirmed';
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRecordDetailPage(
              patientName: name,
              patientId: '#${name.split(' ').first.substring(0, 2).toUpperCase()}-12345',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(period, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade400)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(details, style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400)),
                      const SizedBox(width: 8),
                      _statusBadge(status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.blueGrey.shade300, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isConfirmed = status == 'confirmed';
    final isPending = status == 'pending';
    final isCompleted = status == 'completed';

    Color bgColor = const Color(0xFFBBEBF0);
    Color textColor = const Color(0xFF007580);
    IconData icon = Icons.check_circle;

    if (isPending) {
      bgColor = const Color(0xFFFAF3EC);
      textColor = const Color(0xFFB3672B);
      icon = Icons.watch_later;
    } else if (isCompleted) {
      bgColor = const Color(0xFFF1F5F9);
      textColor = Colors.blueGrey;
      icon = Icons.check_circle_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pastItem(BuildContext context, String timeFull, String name, String details) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRecordDetailPage(
              patientName: name,
              patientId: '#${name.split(' ').first.substring(0, 2).toUpperCase()}-12345',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Text(timeFull, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade500), textAlign: TextAlign.center),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey.shade700)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(details, style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400)),
                      const SizedBox(width: 8),
                      _statusBadge('completed'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.blueGrey.shade300, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAiInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFE0FAFC), const Color(0xFFF1F9FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xFF00C4D4), shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          const Text('Healix AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          Text(
            'Based on today\'s schedule, you have a 30-minute gap between 10:15 and 11:30. Would you like to review Elena Rodriguez\'s updated pathology reports during this time?',
            style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade700, height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007580),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Review Reports', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blueGrey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text('Dismiss', style: TextStyle(color: Colors.blueGrey.shade500, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
