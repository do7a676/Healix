import 'package:flutter/material.dart';
import '../widgets/healix_app_bar.dart';
import '../widgets/healix_background.dart';

class VitalsPage extends StatelessWidget {
  const VitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const HealixAppBar(),
      body: HealixBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Insights',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Real-time monitoring of your body vitals.',
                style: TextStyle(color: subTextColor, fontSize: 16),
              ),
              const SizedBox(height: 32),
              _buildHeartRateCard(context, cardColor, textColor, subTextColor),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildMetricCard('Blood Pressure', '120/80', 'mmHg', Icons.speed, Colors.blue, cardColor, textColor, subTextColor)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetricCard('Blood Oxygen', '98%', 'SpO2', Icons.air, Colors.redAccent, cardColor, textColor, subTextColor)),
                ],
              ),
              const SizedBox(height: 24),
              _buildInsightCard(
                'Sleep Quality',
                '7h 45m',
                'Good',
                0.85,
                Icons.bedtime_outlined,
                Colors.indigo,
                cardColor,
                textColor,
                subTextColor,
              ),
              const SizedBox(height: 24),
              _buildInsightCard(
                'Daily Activity',
                '8,432',
                'Steps',
                0.72,
                Icons.directions_run,
                Colors.orange,
                cardColor,
                textColor,
                subTextColor,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeartRateCard(BuildContext context, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Heart Rate', style: TextStyle(color: subTextColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('72', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(width: 4),
                      Text('BPM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Normal', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: HeartRatePainter(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00']
                .map((t) => Text(t, style: TextStyle(color: subTextColor.withOpacity(0.5), fontSize: 10)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String unit, IconData icon, Color color, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(width: 4),
              Text(unit, style: TextStyle(fontSize: 10, color: subTextColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, String status, double progress, IconData icon, Color color, Color cardColor, Color textColor, Color subTextColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(status, style: TextStyle(color: subTextColor, fontSize: 13)),
                  ],
                ),
              ),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeartRatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00AACD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.1, size.height * 0.65),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.3, size.height * 0.2),
      Offset(size.width * 0.35, size.height * 0.8),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.65),
      Offset(size.width * 0.7, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.85),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.75),
      Offset(size.width, size.height * 0.6),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Shadow path
    final shadowPath = Path.from(path);
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF00AACD).withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, paint);

    // Draw active point
    final activePaint = Paint()
      ..color = const Color(0xFF00AACD)
      ..style = PaintingStyle.fill;
    
    final glowPaint = Paint()
      ..color = const Color(0xFF00AACD).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(points[points.length - 1], 8, glowPaint);
    canvas.drawCircle(points[points.length - 1], 4, activePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
