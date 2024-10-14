class UserModel {
  final String name;
  final String email;
  final String? icon;

  UserModel({required this.name, required this.email, this.icon});

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      email: jsonData['email'],
      name: jsonData["name"],
      icon: jsonData["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'icon': icon,
    };
  }
}
