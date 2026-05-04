import 'package:flutter/material.dart';

class PatientRecordDetailPage extends StatelessWidget {
  final String patientName;
  final String patientId;

  const PatientRecordDetailPage({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Medical Record', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Color(0xFF007580)), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFF334155)), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(isDark, cardColor, textColor, subTextColor),
            const SizedBox(height: 24),
            _buildSectionHeader('AI Health Score', Icons.auto_awesome, textColor),
            const SizedBox(height: 16),
            _buildAiScoreCard(isDark),
            const SizedBox(height: 24),
            _buildSectionHeader('Clinical History', Icons.history, textColor),
            const SizedBox(height: 16),
            _buildHistoryTimeline(isDark, cardColor, textColor, subTextColor),
            const SizedBox(height: 24),
            _buildSectionHeader('Latest Lab Results', Icons.science_outlined, textColor),
            const SizedBox(height: 16),
            _buildLabResultsList(cardColor, textColor, subTextColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildPatientHeader(bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFF007580).withOpacity(0.1),
            child: const Text('MG', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007580))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patientName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                Text('ID: $patientId', style: TextStyle(fontSize: 14, color: subTextColor)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _infoBadge('Age: 42', Colors.blueGrey),
                    const SizedBox(width: 8),
                    _infoBadge('Blood: O+', Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF007580), size: 20),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
      ],
    );
  }

  Widget _buildAiScoreCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007580), Color(0xFF00C4D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Health Stability', style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 4),
                Text('Very High', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text('Based on 14 data points and recent lab results.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: 0.92,
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const Text('92', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    return Column(
      children: [
        _timelineItem('Routine Checkup', 'Oct 12, 2023', 'Stable vitals, continued medication.', true, cardColor, textColor, subTextColor),
        _timelineItem('Lab Submission', 'Sep 28, 2023', 'Lipid panel and metabolic results.', false, cardColor, textColor, subTextColor),
      ],
    );
  }

  Widget _timelineItem(String title, String date, String desc, bool isLast, Color cardColor, Color textColor, Color subTextColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF007580), shape: BoxShape.circle)),
            if (!isLast) Container(width: 2, height: 50, color: const Color(0xFF007580).withOpacity(0.2)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
              Text(date, style: TextStyle(fontSize: 12, color: subTextColor)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabResultsList(Color cardColor, Color textColor, Color subTextColor) {
    return Column(
      children: [
        _labResultItem('Glucose', '98 mg/dL', 'Normal', cardColor, textColor, subTextColor),
        const SizedBox(height: 12),
        _labResultItem('Cholesterol', '185 mg/dL', 'Normal', cardColor, textColor, subTextColor),
      ],
    );
  }

  Widget _labResultItem(String title, String value, String status, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
            Text(status, style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
          ]),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007580),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add Observation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F9FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF007580).withOpacity(0.2)),
              ),
              child: const Icon(Icons.video_call_outlined, color: Color(0xFF007580)),
            ),
          ],
        ),
      ),
    );
  }
}
