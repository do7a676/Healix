import 'package:flutter/material.dart';
import 'patient_record_detail_page.dart';
import '../store/healix_store.dart';

import '../services/doctor_service.dart';

class DoctorDashboardPage extends StatefulWidget {
  final String username;
  const DoctorDashboardPage({super.key, this.username = 'Aris'});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final dId = healixStore.doctorId.value;
    if (dId != null) {
      final apps = await doctorService.getAppointments(dId);
      if (mounted) {
        setState(() {
          _appointments = apps;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.blueGrey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.menu, color: Color(0xFF00C4D4)), onPressed: () {}),
        title: const Text('Healix', style: TextStyle(color: Color(0xFF00C4D4), fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          Stack(alignment: Alignment.center, children: [
            IconButton(icon: Icon(Icons.notifications_none, color: isDark ? Colors.white70 : const Color(0xFF334155)), onPressed: () {}),
            Positioned(right: 12, top: 12, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
          ]),
          Container(
            margin: const EdgeInsets.only(right: 16, left: 8),
            child: const CircleAvatar(radius: 16, backgroundColor: Color(0xFF00C4D4), child: Text('DR', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _fetchData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('TODAY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF007580), letterSpacing: 1.0)),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: healixStore.userName,
                  builder: (context, name, _) => Text('Welcome back, Dr. $name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                ),
                const SizedBox(height: 24),
                _buildBanner(isDark),
                const SizedBox(height: 24),
                _buildScheduleCard(isDark, cardColor, textColor, subTextColor),
                const SizedBox(height: 24),
                _buildStatsRow(isDark),
                const SizedBox(height: 24),
                _buildSectionHeader('Recent Reports', Icons.science_outlined, textColor),
                const SizedBox(height: 16),
                _buildPendingLabs(context, cardColor, textColor, subTextColor),
                const SizedBox(height: 100),
              ]),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF007580),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF007580).withOpacity(0.12) : const Color(0xFFF1F9FB),
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: const Color(0xFF007580).withOpacity(0.3)) : null,
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: isDark ? const Color(0xFF007580).withOpacity(0.2) : const Color(0xFFBBEBF0), shape: BoxShape.circle),
          child: const Icon(Icons.auto_awesome, color: Color(0xFF007580), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Clinical Assistant Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF007580))),
          const SizedBox(height: 4),
          RichText(text: TextSpan(style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade500, height: 1.4), children: const [
            TextSpan(text: '3 critical lab results', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' require your urgent review.'),
          ])),
        ])),
      ]),
    );
  }

  Widget _buildScheduleCard(bool isDark, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Icon(Icons.calendar_today_outlined, color: Color(0xFF007580), size: 20),
            const SizedBox(width: 8),
            Text("Today's Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          ]),
          const Text('View All', style: TextStyle(color: Color(0xFF007580), fontWeight: FontWeight.w600, fontSize: 14)),
        ]),
        const SizedBox(height: 20),
        if (_appointments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No appointments for today', style: TextStyle(color: Colors.grey)),
          )
        else
          ..._appointments.take(3).map((app) {
            final date = DateTime.tryParse(app['appointmentDate'] ?? '') ?? DateTime.now();
            final timeStr = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
            final period = date.hour >= 12 ? 'PM' : 'AM';
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _scheduleItem(
                timeStr, 
                period, 
                app['patientName'] ?? 'Unknown Patient', 
                app['reason'] ?? 'Consultation', 
                false, 
                true, 
                isDark, 
                textColor, 
                subTextColor
              ),
            );
          }).toList(),
      ]),
    );
  }

  Widget _scheduleItem(String time, String period, String name, String type, bool isHighlighted, bool showAction, bool isDark, Color textColor, Color subTextColor) {
    return Container(
      padding: isHighlighted ? const EdgeInsets.all(12) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isHighlighted ? (isDark ? const Color(0xFF007580).withOpacity(0.1) : const Color(0xFFF1F9FB)) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Column(children: [
          Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isHighlighted ? textColor : const Color(0xFF007580))),
          Text(period, style: TextStyle(fontSize: 10, color: subTextColor, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(width: 16),
        Container(width: 2, height: 36, color: isHighlighted ? const Color(0xFF007580) : const Color(0xFFBBEBF0)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor)),
          const SizedBox(height: 2),
          Row(children: [
            Text(type, style: TextStyle(fontSize: 12, color: subTextColor)),
            if (isHighlighted) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: isDark ? const Color(0xFF007580).withOpacity(0.2) : const Color(0xFFBBEBF0), borderRadius: BorderRadius.circular(4)),
                child: const Text('NEXT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF007580))),
              ),
            ]
          ]),
        ])),
        if (showAction)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007580), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), minimumSize: const Size(60, 32), padding: const EdgeInsets.symmetric(horizontal: 16)),
            child: const Text('START', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
      ]),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(children: [
      Expanded(child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF944B11).withOpacity(0.12) : const Color(0xFFFAF3EC),
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: const Color(0xFF944B11).withOpacity(0.3)) : null,
        ),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isDark ? const Color(0xFF944B11).withOpacity(0.2) : const Color(0xFFF3DDC7), shape: BoxShape.circle), child: const Icon(Icons.receipt_long, color: Color(0xFF944B11), size: 20)),
          const SizedBox(height: 12),
          const Text('12', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF944B11))),
          const Text('LABS PENDING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB3672B), letterSpacing: 0.5)),
        ]),
      )),
      const SizedBox(width: 16),
      Expanded(child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF007580).withOpacity(0.12) : const Color(0xFFF1F9FB),
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: const Color(0xFF007580).withOpacity(0.3)) : null,
        ),
        child: Column(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isDark ? const Color(0xFF007580).withOpacity(0.2) : const Color(0xFFD0F0F4), shape: BoxShape.circle), child: const Icon(Icons.people, color: Color(0xFF007580), size: 20)),
          const SizedBox(height: 12),
          const Text('24', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF007580))),
          const Text('DAILY PATIENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0088CC), letterSpacing: 0.5)),
        ]),
      )),
    ]);
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Row(children: [
      Icon(icon, color: const Color(0xFF007580), size: 20),
      const SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
    ]);
  }

  Widget _buildPendingLabs(BuildContext context, Color cardColor, Color textColor, Color subTextColor) {
    return Column(children: [
      _labItem(context, 'Metabolic Panel', 'Marcus Chen', 'AI Processed', true, cardColor, textColor, subTextColor),
      const SizedBox(height: 12),
      _labItem(context, 'Lipid Profile', 'Elena Rodriguez', 'AI Processed', false, cardColor, textColor, subTextColor),
      const SizedBox(height: 12),
      _labItem(context, 'Complete Blood Count', 'Sarah Mitchell', 'AI Processed', false, cardColor, textColor, subTextColor),
    ]);
  }

  Widget _labItem(BuildContext context, String title, String patient, String status, bool isCritical, Color cardColor, Color textColor, Color subTextColor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRecordDetailPage(
              patientName: patient,
              patientId: '#${patient.split(' ').first.substring(0, 2).toUpperCase()}-12345',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: isCritical ? Colors.red : const Color(0xFF007580),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('Patient: $patient', style: TextStyle(fontSize: 12, color: subTextColor)),
                              Text(' • ', style: TextStyle(fontSize: 12, color: subTextColor)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0FAFC),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF007580)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF007580), size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
