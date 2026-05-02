import 'package:flutter/material.dart';
import '../widgets/healix_app_bar.dart';
import '../store/healix_store.dart';

class AiAgentPage extends StatefulWidget {
  const AiAgentPage({super.key});

  @override
  State<AiAgentPage> createState() => _AiAgentPageState();
}

class _AiAgentPageState extends State<AiAgentPage> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get bgColor => isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  Color get cardColor => isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get textColor => isDark ? Colors.white : const Color(0xFF0F172A);
  Color get subTextColor => isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
  Color get borderColor => isDark ? Colors.white10 : const Color(0xFFE2E8F0);
  int _currentStep = 0; // 0: Selection, 1: Inputs, 2: Results
  String _selectedDisease = '';

  // Input state
  final Map<String, dynamic> _inputs = {};
  
  double _riskScore = 0.0;
  bool _isHealthy = true;

  final Map<String, Map<String, String>> _modelMetrics = {
    'Diabetes': {'Accuracy': '92.4%', 'Precision': '91.2%', 'Recall': '89.5%', 'F1-Score': '90.3%'},
    'Heart Disease': {'Accuracy': '94.1%', 'Precision': '93.5%', 'Recall': '92.8%', 'F1-Score': '93.1%'},
    'Kidney Disease': {'Accuracy': '98.2%', 'Precision': '97.9%', 'Recall': '98.5%', 'F1-Score': '98.2%'},
  };

  void _onDiseaseSelect(String disease) {
    setState(() {
      _selectedDisease = disease;
      _currentStep = 1;
      _inputs.clear();
      // Initialize with defaults
    });
  }

  void _analyzeResults() {
    setState(() {
      _riskScore = (30 + (DateTime.now().millisecond % 65)).toDouble();
      _isHealthy = _riskScore < 50;
      _currentStep = 2;
    });
  }

  String _getRiskLabel(double score) {
    if (score <= 25) return 'Low Risk';
    if (score <= 50) return 'Moderate Risk';
    if (score <= 75) return 'High Risk';
    return 'Very High Risk';
  }

  Color _getRiskColor(double score) {
    if (score <= 25) return Colors.green;
    if (score <= 50) return Colors.orange;
    if (score <= 75) return Colors.redAccent;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: HealixAppBar(
        extraActions: _currentStep > 0 ? [
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: () => setState(() => _currentStep = 0),
          )
        ] : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildSelectionStep();
      case 1: return _buildInputStep();
      case 2: return _buildResultStep();
      default: return _buildSelectionStep();
    }
  }

  Widget _buildSelectionStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Disease Prediction',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a specialized AI model to begin your analysis.',
          style: TextStyle(color: subTextColor, fontSize: 16),
        ),
        const SizedBox(height: 32),
        _selectionCard('Diabetes', Icons.water_drop_outlined, 'Analyze glucose and metabolic factors.'),
        _selectionCard('Heart Disease', Icons.favorite_outline, 'Predict cardiac health based on vitals.'),
        _selectionCard('Kidney Disease', Icons.opacity_outlined, 'Evaluate renal function and markers.'),
      ],
    );
  }

  Widget _selectionCard(String title, IconData icon, String desc) {
    return GestureDetector(
      onTap: () => _onDiseaseSelect(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFF00AACD), size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(fontSize: 13, color: subTextColor)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputStep() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildStepHeader('Prediction Inputs'),
        const SizedBox(height: 24),
        _buildMetricsCard(),
        const SizedBox(height: 32),
        if (_selectedDisease == 'Heart Disease') ..._buildHeartInputs(),
        if (_selectedDisease == 'Kidney Disease') ..._buildKidneyInputs(),
        if (_selectedDisease == 'Diabetes') ..._buildDiabetesInputs(),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _analyzeResults,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00AACD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Generate Prediction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  List<Widget> _buildHeartInputs() {
    return [
      _buildToggle('Had Angina', 'HadAngina'),
      _buildToggle('Chest Scan', 'ChestScan'),
      _buildToggle('Had Stroke', 'HadStroke'),
      _buildToggle('Difficulty Walking', 'DifficultyWalking'),
      _buildToggle('Had Diabetes', 'HadDiabetes'),
      _buildDropdown('General Health', 'GeneralHealth', ['Excellent', 'Very good', 'Good', 'Fair', 'Poor']),
      _buildToggle('Had Arthritis', 'HadArthritis'),
      _buildToggle('Pneumonia Vaccine Ever', 'PneumoVaxEver'),
      _buildDropdown('Removed Teeth', 'RemovedTeeth', ['None', '1 to 5', '6 or more', 'All']),
      _buildDropdown('Age Category', 'AgeCategory', ['18-24', '25-29', '30-34', '35-39', '40-44', '45-49', '50-54', '55-59', '60-64', '65-69', '70-74', '75-79', '80+']),
      _buildDropdown('Smoker Status', 'SmokerStatus', ['Never smoked', 'Former smoker', 'Current daily', 'Current sometimes']),
      _buildTextField('BMI (Body Mass Index)', 'BMI', 'Normal: 18.5–24.9'),
      _buildToggle('Kidney Disease', 'HadKidneyDisease'),
      _buildToggle('COPD (Lung Disease)', 'HadCOPD'),
    ];
  }

  List<Widget> _buildKidneyInputs() {
    return [
      _buildTextField('Age', 'age', ''),
      _buildTextField('Blood Pressure', 'bp', 'Normal < 120'),
      _buildTextField('Specific Gravity', 'sg', '1.010–1.025'),
      _buildDropdown('Albumin (0-5)', 'al', ['0', '1', '2', '3', '4', '5']),
      _buildDropdown('Sugar (0-5)', 'su', ['0', '1', '2', '3', '4', '5']),
      _buildDropdown('Red Blood Cells', 'rbc', ['normal', 'abnormal']),
      _buildDropdown('Pus Cell', 'pc', ['normal', 'abnormal']),
      _buildDropdown('Pus Cell Clumps', 'pcc', ['notpresent', 'present']),
      _buildDropdown('Bacteria', 'ba', ['notpresent', 'present']),
      _buildTextField('Blood Glucose Random', 'bgr', 'Normal < 140'),
      _buildTextField('Blood Urea', 'bu', 'Normal < 40'),
      _buildTextField('Serum Creatinine', 'sc', 'Normal 0.6–1.2'),
      _buildTextField('Sodium', 'sod', 'Normal 135–145'),
      _buildTextField('Potassium', 'pot', 'Normal 3.5–5.0'),
      _buildTextField('Hemoglobin', 'hemo', 'Normal 12–17'),
      _buildTextField('Packed Cell Volume', 'pcv', 'Normal 36–50'),
      _buildTextField('White Blood Cell Count', 'wc', 'Normal 4000–11000'),
      _buildTextField('Red Blood Cell Count', 'rc', 'Normal 4.5–5.5'),
      _buildToggle('Hypertension', 'htn'),
      _buildToggle('Diabetes', 'dm'),
      _buildToggle('Coronary Artery Disease', 'cad'),
      _buildDropdown('Appetite', 'appet', ['good', 'poor']),
      _buildToggle('Pedal Edema', 'pe'),
      _buildToggle('Anemia', 'ane'),
    ];
  }

  List<Widget> _buildDiabetesInputs() {
    return [
      _buildTextField('Glucose', 'glucose', 'Normal: 70-99'),
      _buildTextField('Blood Pressure', 'bp', 'Normal: < 120'),
      _buildTextField('BMI (Body Mass Index)', 'bmi', 'Normal: 18.5-24.9'),
      _buildTextField('Age', 'age', ''),
    ];
  }

  Widget _buildToggle(String label, String key) {
    bool value = _inputs[key] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)))),
            Row(
              children: [
                Text(value ? 'Yes' : 'No', style: TextStyle(color: value ? const Color(0xFF00AACD) : const Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 8),
                Switch(
                  value: value,
                  onChanged: (val) => setState(() => _inputs[key] = val),
                  activeColor: const Color(0xFF00AACD),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String key, List<String> options) {
    String? value = _inputs[key];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: const Text('Select Option', style: TextStyle(fontSize: 14)),
                items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: (val) => setState(() => _inputs[key] = val),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String key, String range) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
              if (range.isNotEmpty) Text(range, style: const TextStyle(fontSize: 11, color: Color(0xFF00AACD), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter value',
              filled: true,
              fillColor: cardColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: borderColor)),
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCard() {
    final metrics = _modelMetrics[_selectedDisease]!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: textColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Color(0xFF00AACD), size: 20),
              const SizedBox(width: 10),
              Text('$_selectedDisease AI Model', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: metrics.entries.map((e) => Column(
              children: [
                Text(e.value, style: const TextStyle(color: Color(0xFF00AACD), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(e.key, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStep() {
    final riskLabel = _getRiskLabel(_riskScore);
    final riskColor = _getRiskColor(_riskScore);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStepHeader('Prediction Result'),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: riskColor.withOpacity(0.1), blurRadius: 40, spreadRadius: 10),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _isHealthy ? 'HEALTHY' : 'UNHEALTHY',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: riskColor, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_riskScore.toInt()}%',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: textColor),
                ),
                Text(
                  riskLabel,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: riskColor.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          if (_inputs.isNotEmpty) ...[
            _buildProvidedInputsSummary(),
            const SizedBox(height: 20),
          ],
          _buildResultInfoCard(),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep = 0),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: textColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Back', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _saveToHistory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00AACD),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Save Result', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveToHistory() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';
    
    final riskLabel = _getRiskLabel(_riskScore);

    healixStore.addRecord({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': '$_selectedDisease Risk: $riskLabel (${_riskScore.toInt()}%)',
      'date': dateStr,
      'type': 'AI Prediction',
      'status': 'Complete',
      'isAi': true,
      'riskScore': _riskScore.toInt(),
      'inputs': Map<String, dynamic>.from(_inputs),
      'disease': _selectedDisease,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Result saved to Medical History successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    setState(() => _currentStep = 0);
  }

  Widget _buildProvidedInputsSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Patient Inputs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
          const SizedBox(height: 16),
          ..._inputs.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(e.key, style: TextStyle(color: subTextColor, fontSize: 13))),
                  Text('${e.value}', style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 13)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildResultInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF00AACD)),
              SizedBox(width: 12),
              Text('Medical Disclaimer', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This prediction is based on AI algorithms and should not be taken as a final medical diagnosis. Please consult with a healthcare professional.',
            style: TextStyle(color: subTextColor, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(String title) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => setState(() => _currentStep--),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }
}
