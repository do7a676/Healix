import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorAiResultPage extends StatefulWidget {
  const DoctorAiResultPage({super.key});

  @override
  State<DoctorAiResultPage> createState() => _DoctorAiResultPageState();
}

class _DoctorAiResultPageState extends State<DoctorAiResultPage> {
  final TextEditingController _reportController1 = TextEditingController();
  final TextEditingController _reportController2 = TextEditingController();
  final TextEditingController _reportController3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReports();
    
    _reportController1.addListener(() => _saveReport('ai_report_1', _reportController1.text));
    _reportController2.addListener(() => _saveReport('ai_report_2', _reportController2.text));
    _reportController3.addListener(() => _saveReport('ai_report_3', _reportController3.text));
  }

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _reportController1.text = prefs.getString('ai_report_1') ?? '';
        _reportController2.text = prefs.getString('ai_report_2') ?? '';
        _reportController3.text = prefs.getString('ai_report_3') ?? '';
      });
    }
  }

  Future<void> _saveReport(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  void dispose() {
    _reportController1.dispose();
    _reportController2.dispose();
    _reportController3.dispose();
    super.dispose();
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
        title: Text('AI Agent Results', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Submissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Text('Review AI-processed symptoms from your patients.', style: TextStyle(fontSize: 14, color: subTextColor)),
            const SizedBox(height: 24),
            _buildPatientSubmissionCard(
              name: 'Marcus Chen', time: 'Submitted 2 hours ago',
              labs: [_buildLabResultRow('Glucose (Fasting)', '6.2', 'mmol/L', '4.0 - 5.6', isAbnormal: true), const Divider(), _buildLabResultRow('ALT', '45', 'IU/L', '3 - 35', isAbnormal: true), const Divider(), _buildLabResultRow('AST', '38', 'IU/L', '1 - 35', isAbnormal: true), const Divider(), _buildLabResultRow('WBC', '8.5', '×10⁹/L', '3.9 - 10', isAbnormal: false), const Divider(), _buildLabResultRow('Hemoglobin (Hb)', '140', 'g/L', '130 - 170', isAbnormal: false)],
              aiTitle: 'Possible Mild Hepatic Stress / Pre-diabetes', aiDescription: 'Elevated fasting glucose indicates impaired glucose tolerance. Mild elevation in ALT and AST suggests early hepatic stress. Recommend follow-up HbA1c and ultrasound. Confidence: High.',
              isUrgent: true, controller: _reportController1, isDark: isDark, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor,
            ),
            const SizedBox(height: 24),
            _buildPatientSubmissionCard(
              name: 'Elena Rodriguez', time: 'Submitted 5 hours ago',
              labs: [_buildLabResultRow('WBC', '11.2', '×10⁹/L', '3.9 - 10', isAbnormal: true), const Divider(), _buildLabResultRow('Neutrophils', '8.1', '×10⁹/L', '1.7 - 7.5', isAbnormal: true), const Divider(), _buildLabResultRow('Hemoglobin (Hb)', '125', 'g/L', '120 - 150', isAbnormal: false)],
              aiTitle: 'Suspected Bacterial Infection', aiDescription: 'Elevated WBC and Neutrophils suggest an active bacterial infection. Recommend clinical correlation and possible antibiotic therapy. Confidence: High.',
              isUrgent: true, controller: _reportController2, isDark: isDark, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor,
            ),
            const SizedBox(height: 24),
            _buildPatientSubmissionCard(
              name: 'Sarah Mitchell', time: 'Submitted Yesterday',
              labs: [_buildLabResultRow('Total Protein', '70', 'g/L', '66 - 83', isAbnormal: false), const Divider(), _buildLabResultRow('Albumin', '42', 'g/L', '35 - 52', isAbnormal: false), const Divider(), _buildLabResultRow('Total Bilirubin', '12', 'µmol/L', '5 - 21', isAbnormal: false)],
              aiTitle: 'Normal Liver Function', aiDescription: 'All liver markers are within normal clinical ranges. No immediate action required. Confidence: Very High.',
              isUrgent: false, controller: _reportController3, isDark: isDark, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientSubmissionCard({
    required String name, required String time, required List<Widget> labs,
    required String aiTitle, required String aiDescription, required bool isUrgent,
    required TextEditingController controller,
    required bool isDark, required Color cardColor, required Color textColor, required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isDark ? const Color(0xFF007580).withOpacity(0.2) : const Color(0xFFF1F9FB),
                    child: const Icon(Icons.person, color: Color(0xFF007580)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                      Text(time, style: TextStyle(fontSize: 12, color: subTextColor)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUrgent ? const Color(0xFFFFEDD5) : const Color(0xFFE0FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isUrgent ? 'PENDING REVIEW' : 'REVIEWED',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isUrgent ? Colors.deepOrange : const Color(0xFF007580)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Submitted Lab Results:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? const Color(0xFF00C4D4) : const Color(0xFF007580))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
            ),
            child: Column(
              children: labs,
            ),
          ),
          const SizedBox(height: 20),
          Text('AI Preliminary Analysis:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? const Color(0xFF00C4D4) : const Color(0xFF007580))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF00C4D4).withOpacity(0.08) : const Color(0xFFE0FAFC).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF00C4D4), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aiTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                      const SizedBox(height: 4),
                      Text(aiDescription, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : null)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Do you agree with this AI analysis?', style: TextStyle(fontSize: 12, color: Color(0xFF334155))),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  controller.text = 'I concur with the AI preliminary analysis. Proceed with standard protocol.';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.thumb_up_outlined, size: 14, color: Colors.blueGrey),
                      SizedBox(width: 4),
                      Text('Agree', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  controller.text = 'I disagree with the AI analysis. The clinical picture suggests... ';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.thumb_down_outlined, size: 14, color: Colors.blueGrey),
                      SizedBox(width: 4),
                      Text('Disagree', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text("Doctor's Report / Clinical Notes:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 4,
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF334155)),
            decoration: InputDecoration(
              hintText: 'Write your professional assessment here...',
              hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.blueGrey.shade300, fontSize: 13),
              filled: true,
              fillColor: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
              focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: Color(0xFF00C4D4))),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to submit report
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007580),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Submit Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Logic to request appointment
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.blueGrey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Request Visit', style: TextStyle(color: Colors.blueGrey.shade600, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultRow(String testName, String value, String unit, String range, {required bool isAbnormal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(testName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155))),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isAbnormal ? Colors.deepOrange : const Color(0xFF007580),
                  ),
                ),
                if (isAbnormal) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_upward, color: Colors.deepOrange, size: 14),
                ]
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(unit, style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400)),
          ),
          Expanded(
            flex: 1,
            child: Text(range, style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400)),
          ),
        ],
      ),
    );
  }
}
