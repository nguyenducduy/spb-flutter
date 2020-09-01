class UserGraphql {
  static String login =
      """mutation loginUser(\$uid: String!, \$email: String!, \$fullName: String!, \$accessToken: String!) {
    loginUser(uid: \$uid, email: \$email, fullName: \$fullName, accessToken: \$accessToken) {
      user {
        id
        email
        fullName
      }
      token
    }
  }""";
}
