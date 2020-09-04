class PillForm {
  static String list = """query listPillForm {
      listPillForm(first: 100, last: 100, sort: [ID_ASC]) {
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
}
