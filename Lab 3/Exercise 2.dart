import 'dart:convert';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(Name: $name, Email: $email)';
}

Future<List<User>> fetchAndParseUsers() async {
  String jsonRawString = '[{"name": "Trần Văn B", "email": "b.tran@api.com"}, {"name": "Lê Thị C", "email": "c.le@api.com"}]';
  
  await Future.delayed(Duration(milliseconds: 500)); 

  List<dynamic> decodedData = jsonDecode(jsonRawString);

  return decodedData.map((item) => User.fromJson(item)).toList();
}

void main() async {
  print("--- Lab 3 - Exercise 2 Output ---");
  print("Đang tải danh sách người dùng...");
  
  List<User> userList = await fetchAndParseUsers();
  print("Danh sách User sau khi Parse JSON thành công:");
  userList.forEach((user) => print(user));
}