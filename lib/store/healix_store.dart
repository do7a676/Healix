import 'package:flutter/material.dart';

class HealixStore {
  static final HealixStore _instance = HealixStore._internal();
  factory HealixStore() => _instance;
  HealixStore._internal();

  final ValueNotifier<Map<String, dynamic>?> lastAppointment = ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<String> userName = ValueNotifier<String>('Alex');
  final ValueNotifier<String?> profileImageUrl = ValueNotifier<String?>(null);
  final ValueNotifier<List<Map<String, dynamic>>> historyRecords = ValueNotifier<List<Map<String, dynamic>>>([
    {
      'id': '1',
      'title': 'Full Body Checkup',
      'date': 'Oct 20, 2023',
      'type': 'Laboratory',
      'status': 'Completed',
    },
    {
      'id': '2',
      'title': 'Heart Rate Analysis',
      'date': 'Oct 18, 2023',
      'type': 'AI Analysis',
      'status': 'Stable',
    },
    {
      'id': '3',
      'title': 'Blood Pressure Test',
      'date': 'Oct 15, 2023',
      'type': 'Vitals Check',
      'status': 'Normal',
    },
  ]);

  final ValueNotifier<List<Map<String, dynamic>>> notifications = ValueNotifier<List<Map<String, dynamic>>>([
    {
      'id': '1',
      'title': 'Appointment Confirmed',
      'body': 'Your appointment with Dr. Sarah Chen is confirmed for Oct 25.',
      'time': '2h ago',
      'icon': Icons.check_circle_outline,
      'color': Colors.green,
    },
    {
      'id': '2',
      'title': 'New Lab Result',
      'body': 'Your Full Body Checkup results are now available for review.',
      'time': '5h ago',
      'icon': Icons.description_outlined,
      'color': Colors.blue,
    },
    {
      'id': '3',
      'title': 'Health Alert',
      'body': 'Your heart rate was slightly higher than usual this morning.',
      'time': '1d ago',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.orange,
    },
  ]);

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
