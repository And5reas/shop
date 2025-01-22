import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/errors/http_exception.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    final ProductList productList = Provider.of(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.productForm,
                arguments: product,
              ),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Excluir Produto'),
                  content: Text('Quer remover o produto da Loja?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('Não'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text('Sim'),
                    ),
                  ],
                ),
              ).then(
                (value) async {
                  try {
                    if (value ?? false) {
                      await productList.deleteProduct(product);
                    }
                  } on HttpException catch (err) {
                    msg.showSnackBar(SnackBar(
                      content: Text(err.toString()),
                    ));
                  }
                },
              ),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
