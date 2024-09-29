class UserModel {
  String name;
  String email;
  String userId;
  String registerDate;
  UserModel(
      {required this.email,
      required this.name,
      required this.userId,
      required this.registerDate});

  factory UserModel.fromJson(Map<String, dynamic> json, String userId) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      userId: userId,
      registerDate: json['registerDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['userId'] = userId;
    data['registerDate'] = registerDate;
    return data;
  }
}
