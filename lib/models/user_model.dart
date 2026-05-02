class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String role; // 'patient' | 'doctor'
  final String? token;
  final int? age;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.token,
    this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['Id'] ?? json['id'] ?? 0,
      fullName: json['FullName'] ?? json['fullName'] ?? json['name'] ?? '',
      email: json['Email'] ?? json['email'] ?? '',
      role: json['Role'] ?? json['role'] ?? 'patient',
      token: json['Token'] ?? json['token'],
      age: json['Age'] ?? json['age'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Id': id,
    'FullName': fullName,
    'Email': email,
    'Role': role,
    'Token': token,
    'Age': age,
  };
}
