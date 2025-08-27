import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../model/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      provider.loadInitialProducts();

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          provider.loadMoreProducts();
        }
      });
    });
  }
  Future<void> shareProduct(String title, String url) async {
    await FlutterShare.share(
      title: title,
      text: 'Check out this product!',
      linkUrl: url,
      chooserTitle: 'Share $title',
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stikky Products List")),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                provider.products.length + (provider.hasNextPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < provider.products.length) {
                final Product product = provider.products[index];
                return ListTile(
                  leading:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 100,height: 120,
                        child: product.imageUrl != null
                            ? Image.network(product.imageUrl!, )
                        : const Icon(Icons.image_not_supported)),
                  ),
                  title: Text(product.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: ${product.price}"),
                      if (product.compareAtPrice != null)
                        Text(
                          "Was: ${product.compareAtPrice}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    print(product.onlineStoreUrl);
                    if (product.onlineStoreUrl != null) {
                      if (product.onlineStoreUrl != null) {
                        shareProduct(product.title, product.onlineStoreUrl!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product link not available")),
                        );
                      }
                    }
                  },
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
