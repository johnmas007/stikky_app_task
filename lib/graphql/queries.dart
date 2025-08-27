const String getProductsQuery = r'''
query GetProducts($cursor: String) {
  products(first: 10, after: $cursor) {
    edges {
      cursor
      node {
        title
        onlineStoreUrl
        images(first: 1) {
          edges {
            node {
              url
            }
          }
        }
        variants(first: 1) {
          edges {
            node {
              price {
                amount
                currencyCode
              }
              compareAtPrice {
                amount
                currencyCode
              }
            }
          }
        }
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
''';
