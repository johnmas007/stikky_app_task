import 'package:graphql_flutter/graphql_flutter.dart';

class ShopifyGraphQL {
  static GraphQLClient initClient() {
    final HttpLink httpLink = HttpLink(
      "https://stikky-dev-assessment.myshopify.com/api/2024-07/graphql.json", // replace with your shopify store URL
      defaultHeaders: {
        "X-Shopify-Storefront-Access-Token": "d2c471e3b040cda6c07f5a6e5f558541",
      },
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
}
