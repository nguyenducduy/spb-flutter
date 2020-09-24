class User {
  int id;
  String email;
  String fullName;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        fullName = json['fullName'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'email': email, 'fullName': fullName};
}
