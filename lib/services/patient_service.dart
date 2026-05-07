import '../core/network/api_service.dart';
import '../store/healix_store.dart';

class PatientService {
  final ApiService _api = ApiService();
  
  static final PatientService _instance = PatientService._internal();
  factory PatientService() => _instance;
  PatientService._internal();

  Future<List<Map<String, dynamic>>> getAppointments(String patientId) async {
    try {
      final response = await _api.get('/appointments/patient/$patientId');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    try {
      final patientId = healixStore.patientId.value;
      if (patientId == null) return [];

      final response = await _api.get('/records/patient/$patientId');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createAppointment({
    required int doctorId,
    required int patientId,
    required DateTime appointmentDate,
    required String reason,
  }) async {
    try {
      final response = await _api.post('/appointments', data: {
        'doctorId': doctorId,
        'patientId': patientId,
        'appointmentDate': appointmentDate.toIso8601String(),
        'reason': reason,
        'status': 0, // Pending
      });
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

final patientService = PatientService();
