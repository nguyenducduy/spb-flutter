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
}
