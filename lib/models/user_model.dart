
class UserModel {
  String name;
  String email;
  int data;

  UserModel({
    required this.name,
    required this.email,
    required this.data,
  });

  // Correct factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      data: json['dataUsed'] ?? 0, // matches your backend field
    );
  }

  // Optional: convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "dataUsed": data,
    };
  }
}