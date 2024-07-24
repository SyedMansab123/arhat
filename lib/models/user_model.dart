class CustomUserModel {
  final String id;
  final String userName;
  final String email;

  CustomUserModel(
      {required this.id, required this.userName, required this.email});

  factory CustomUserModel.fromMap(String id, Map<String, dynamic> data) {
    return CustomUserModel(
      id: id,
      userName: data['userName'] ?? '',
      email: data['email'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
    };
  }
}
