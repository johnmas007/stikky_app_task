import 'package:graphql_flutter/graphql_flutter.dart';
import '../core/graphql_client.dart';
import '../graphql/queries.dart';
import '../model/product.dart';

class ProductController {
  final GraphQLClient client = ShopifyGraphQL.initClient();

  Future<Map<String, dynamic>> fetchProducts({String? cursor}) async {
    final result = await client.query(
      QueryOptions(
        document: gql(getProductsQuery),
        variables: {"cursor": cursor},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final edges = result.data!["products"]["edges"] as List;
    final pageInfo = result.data!["products"]["pageInfo"];

    final products = edges.map((e) => Product.fromJson(e["node"])).toList();

    return {
      "products": products,
      "endCursor": pageInfo["endCursor"],
      "hasNextPage": pageInfo["hasNextPage"],
    };
  }
}
