import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PatientRecordDetailPage extends StatefulWidget {
  final String patientName;
  final String patientId;

  const PatientRecordDetailPage({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  @override
  State<PatientRecordDetailPage> createState() => _PatientRecordDetailPageState();
}

class _PatientRecordDetailPageState extends State<PatientRecordDetailPage> {
  bool _showAiDetails = false;
  List<String> _observations = [
    'Stable vitals, continued medication.',
    'Lipid panel and metabolic results.'
  ];
  final TextEditingController _reportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String obsKey = 'obs_${widget.patientId}';
    final String reportKey = 'report_${widget.patientId}';

    final List<String>? savedObs = prefs.getStringList(obsKey);
    final String? savedReport = prefs.getString(reportKey);

    if (mounted) {
      setState(() {
        if (savedObs != null) _observations = savedObs;
        if (savedReport != null) _reportController.text = savedReport;
      });
    }
    
    _reportController.addListener(() {
      prefs.setString(reportKey, _reportController.text);
    });
  }

  Future<void> _saveObservations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('obs_${widget.patientId}', _observations);
  }

  void _addObservation() {
    showDialog(
      context: context,
      builder: (context) {
        String newObs = '';
        return AlertDialog(
          title: const Text('Add Observation'),
          content: TextField(
            onChanged: (value) => newObs = value,
            decoration: const InputDecoration(hintText: "Enter observation..."),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (newObs.isNotEmpty) {
                  setState(() => _observations.insert(0, newObs));
                  await _saveObservations();
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

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
        title: Image.asset(
          'assets/images/logo_full.jpeg',
          height: 25,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Color(0xFF007580)), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(isDark, cardColor, textColor, subTextColor),
            const SizedBox(height: 24),
            _buildSectionHeader('AI Agent Results', Icons.auto_awesome, textColor),
            const SizedBox(height: 16),
            _buildAiScoreCard(isDark),
            if (_showAiDetails) _buildAiAgentInputDetails(cardColor, textColor, subTextColor),
            const SizedBox(height: 24),
            _buildSectionHeader('Doctor Report', Icons.description_outlined, textColor),
            const SizedBox(height: 16),
            _buildReportField(cardColor, textColor),
            const SizedBox(height: 24),
            _buildSectionHeader('Clinical Observations', Icons.history, textColor),
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
            child: Text(widget.patientName.substring(0, 1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF007580))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.patientName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                Text('ID: ${widget.patientId}', style: TextStyle(fontSize: 14, color: subTextColor)),
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
    return InkWell(
      onTap: () => setState(() => _showAiDetails = !_showAiDetails),
      child: Container(
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
                children: [
                  const Text('Health Stability', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Very High', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(_showAiDetails ? 'Tap to hide details' : 'Tap to see AI Agent Input', style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
      ),
    );
  }

  Widget _buildAiAgentInputDetails(Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF007580).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Agent Input / Reasoning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF007580))),
          const SizedBox(height: 8),
          Text(
            'Analyzing 14 clinical data points including recent glucose levels, blood pressure, and historical trends. AI predicts high stability based on consistent recovery markers.',
            style: TextStyle(fontSize: 13, color: subTextColor, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReportField(Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _reportController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Enter your professional report...',
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildHistoryTimeline(bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    return Column(
      children: List.generate(_observations.length, (index) {
        return _timelineItem(
          index == 0 ? 'Latest Visit' : 'Past Visit',
          'Oct ${12 - index}, 2023',
          _observations[index],
          index == _observations.length - 1,
          cardColor,
          textColor,
          subTextColor,
          index,
        );
      }),
    );
  }

  Widget _timelineItem(String title, String date, String desc, bool isLast, Color cardColor, Color textColor, Color subTextColor, int index) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: () async {
                      setState(() => _observations.removeAt(index));
                      await _saveObservations();
                    },
                  ),
                ],
              ),
              Text(date, style: TextStyle(fontSize: 12, color: subTextColor)),
              const SizedBox(height: 4),
              Text(desc, style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 12),
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
                onPressed: _addObservation,
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

