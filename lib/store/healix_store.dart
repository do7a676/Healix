import 'package:flutter/material.dart';

class HealixStore {
  static final HealixStore _instance = HealixStore._internal();
  factory HealixStore() => _instance;
  HealixStore._internal();

  final ValueNotifier<Map<String, dynamic>?> lastAppointment = ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<String> userName = ValueNotifier<String>('User');
  final ValueNotifier<String?> profileImageUrl = ValueNotifier<String?>(null);
  final ValueNotifier<String?> patientId = ValueNotifier<String?>(null);
  final ValueNotifier<String?> doctorId = ValueNotifier<String?>(null);
  
  final ValueNotifier<List<Map<String, dynamic>>> historyRecords = ValueNotifier<List<Map<String, dynamic>>>([]);
  final ValueNotifier<List<Map<String, dynamic>>> notifications = ValueNotifier<List<Map<String, dynamic>>>([]);

  void setAppointment(String doctorName, String date, String time) {
    lastAppointment.value = {
      'doctorName': doctorName,
      'date': date,
      'time': time,
    };
  }

  void setUserName(String name) {
    userName.value = name;
  }

  void removeRecord(String id) {
    historyRecords.value = List.from(historyRecords.value)..removeWhere((record) => record['id'] == id);
  }

  void addRecord(Map<String, dynamic> record) {
    historyRecords.value = [record, ...historyRecords.value];
  }

  void clearNotifications() {
    notifications.value = [];
  }
}

final healixStore = HealixStore();
