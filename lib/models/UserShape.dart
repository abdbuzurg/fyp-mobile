class UserShape {
  final String email;
  final String username;
  final String name;
  final String mobileNumber;

  UserShape({this.email, this.username, this.name, this.mobileNumber});

  factory UserShape.from(Map<String, dynamic> result) {
    return UserShape(
        email: result["email"],
        username: result["username"],
        name: result["name"],
        mobileNumber: result["mobileNumber"]);
  }
}
