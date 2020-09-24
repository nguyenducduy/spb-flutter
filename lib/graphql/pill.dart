class Pill {
  static String search = """query listPill(\$filters: PillFilter!) {
      listPill(first: 5, last: 10, sort: [ID_ASC], filters: \$filters) {
        totalCount
        edges {
          node {
            id
            name
          }
        }
      }
    }
    """;

  static String add =
      """mutation createUserPillDevice(\$name: String!, \$pillFormId: Int!, \$deviceId: Int!, \$amount: String!, \$remain: String!, \$note: String) {
    createUserPillDevice(name: \$name, pillFormId: \$pillFormId, deviceId: \$deviceId, amount: \$amount, remain: \$remain, note: \$note) {
      userPillDevice {
        amount
        remain
        note
      }
    }
  }""";
}
