class Auth {
  static String register(String name, String username, String email,
      String password, String mobileNumber) {
    return """
      mutation{
        register(
        mobileNumber:"$mobileNumber",
        name:"$name",
        username: "$username",
        email: "$email",
        password: "$password"
        ){
          id
        }
      }
    """;
  }

  static String login(String user, String password) {
    return """ 
    mutation{
      login(username:"$user", password:"$password"){
        token
      }
    }
    """;
  }

  static String logout() {
    return """
      mutation{
        logout
      }
    """;
  }
}
