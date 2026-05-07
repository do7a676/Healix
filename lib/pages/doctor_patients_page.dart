import 'package:flutter/material.dart';
import 'doctor_profile_page.dart';
import 'patient_record_detail_page.dart';

class DoctorPatientsPage extends StatelessWidget {
  const DoctorPatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400;
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00C4D4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.security, color: Colors.white, size: 18),
          ),
        ),
        title: Image.asset(
          'assets/images/logo_full.jpeg',
          height: 32,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: isDark ? Colors.white70 : const Color(0xFF334155)),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorProfilePage()));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: TextField(
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: subTextColor),
                  hintText: 'Search by name, ID, or condition',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildFilterChip('Recently Visited', true, isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Alphabetical', false, isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Urgent Review', false, isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF007580).withOpacity(0.15) : const Color(0xFFE0FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: isDark ? Border.all(color: const Color(0xFF007580).withOpacity(0.3)) : null,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL PATIENTS', style: TextStyle(color: Color(0xFF007580), fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('1,284', style: TextStyle(color: Color(0xFF007580), fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFFB91C1C).withOpacity(0.15) : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(16),
                      border: isDark ? Border.all(color: const Color(0xFFB91C1C).withOpacity(0.3)) : null,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('URGENT ACTION', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('12', style: TextStyle(color: Color(0xFFB91C1C), fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Text(
              'Active Cases',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            
            // Patient Cards
            _buildPatientCard(
              context: context,
              name: 'Maria Garcia', id: '#ER-99201', status: 'Stable', isUrgent: false,
              dateOrTime: 'Oct 12, 2023', dateIcon: Icons.calendar_today,
              condition: 'Vitals Normal', conditionIcon: Icons.monitor_heart_outlined,
              isDark: isDark, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor, borderColor: borderColor,
            ),
            _buildPatientCard(
              context: context,
              name: 'James Wilson', id: '#IC-44021', status: 'Needs Review', isUrgent: true,
              dateOrTime: '2h ago', dateIcon: Icons.access_time_filled,
              condition: 'Elevated Temp', conditionIcon: Icons.thermostat,
              isDark: isDark, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor, borderColor: borderColor,
            ),
            _buildPatientCard(
              context: context,
              name: 'Sarah Lee', id: '#ER-99205', status: 'Stable', isUrgent: false,
              dateOrTime: 'Oct 11, 2023', dateIcon: Icons.calendar_today,
              condition: 'Medication Plan', conditionIcon: Icons.medical_services_outlined,
              isDark: isDark, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor, borderColor: borderColor,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF007580) : (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF007580) : (isDark ? Colors.white12 : Colors.grey.shade300)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : (isDark ? Colors.grey.shade300 : Colors.blueGrey.shade700),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPatientCard({
    required BuildContext context,
    required String name, required String id, required String status, required bool isUrgent,
    required String dateOrTime, required IconData dateIcon, required String condition, required IconData conditionIcon,
    required bool isDark, required Color cardColor, required Color textColor, required Color subTextColor, required Color borderColor,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRecordDetailPage(
              patientName: name,
              patientId: id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
          ],
          border: isUrgent
              ? const Border(left: BorderSide(color: Color(0xFFDC2626), width: 4))
              : Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                        Text('ID: $id', style: TextStyle(fontSize: 12, color: subTextColor)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? (isDark ? const Color(0xFFDC2626).withOpacity(0.15) : const Color(0xFFFEE2E2))
                          : (isDark ? const Color(0xFF059669).withOpacity(0.15) : const Color(0xFFD1FAE5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isUrgent ? const Color(0xFFDC2626) : const Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(dateIcon, size: 14, color: isUrgent ? const Color(0xFFDC2626) : subTextColor),
                  const SizedBox(width: 4),
                  Text(
                    dateOrTime,
                    style: TextStyle(fontSize: 12, fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal, color: isUrgent ? const Color(0xFFDC2626) : subTextColor),
                  ),
                  const SizedBox(width: 16),
                  Icon(conditionIcon, size: 14, color: subTextColor),
                  const SizedBox(width: 4),
                  Text(condition, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: subTextColor)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildActionIcon(Icons.description, isDark: isDark),
                  const SizedBox(width: 8),
                  _buildActionIcon(Icons.medical_services, isTeal: true, isDark: isDark),
                  const SizedBox(width: 8),
                  _buildActionIcon(Icons.history, isDark: isDark),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: subTextColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {bool isTeal = false, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isTeal
            ? (isDark ? const Color(0xFF007580).withOpacity(0.15) : const Color(0xFFE0FAFC))
            : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: isTeal ? const Color(0xFF007580) : (isDark ? Colors.white54 : const Color(0xFF334155))),
    );
  }
}
