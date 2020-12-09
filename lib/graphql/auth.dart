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
        userId
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

  static String getUserById(int id) {
    return """
      {
      user(id: $id){
        email
        username
        name
        mobileNumber
      }
    }
    """;
  }
}
