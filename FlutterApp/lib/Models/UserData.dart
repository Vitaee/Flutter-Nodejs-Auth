class UserData {
  final int status;
  final String username;
  final String email;
  final bool loggedin;

  UserData({this.status, this.username, this.email, this.loggedin});

  factory UserData.fromJson(Map<String, dynamic> json) {
    print(json);
    return UserData(
      status: json['status'],
      username: json['username'],
      email: json['email'],
      loggedin: json['loggedin'],
    );
  }
}
