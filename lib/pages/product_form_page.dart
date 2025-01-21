import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = {};

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool isNetworkUrl = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');
    bool hasExtensionUrl = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.webp') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && isNetworkUrl && hasExtensionUrl;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Provider.of<ProductList>(context, listen: false).saveProduct(_formData);

    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final Product product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['name']?.toString(),
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocus),
                onSaved: (name) => _formData['name'] = name ?? '',
                validator: (value) {
                  final name = value ?? '';

                  if (name.trim().isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }

                  if (name.trim().length < 3) {
                    return 'Nome muito pequeno, por favor, insira um nome maior';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                focusNode: _priceFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_imageUrlFocus),
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
                validator: (value) {
                  final priceString = value ?? '-1';
                  final price = double.tryParse(priceString) ?? -1;

                  if (price <= 0) {
                    return 'Por favor, informe um preço válido';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(labelText: 'Url da Imagem'),
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocus),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '0',
                      validator: (value) {
                        final imageUrl = value ?? '';

                        if (!isValidImageUrl(imageUrl)) {
                          return 'Por favor, insira uma url válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 20, left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : SizedBox(
                            height: 100,
                            width: 100,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.network(_imageUrlController.text),
                            ),
                          ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: InputDecoration(labelText: 'Descrição'),
                focusNode: _descriptionFocus,
                onFieldSubmitted: (_) => _submitForm(),
                onSaved: (description) =>
                    _formData['description'] = description ?? '0',
                validator: (value) {
                  final name = value ?? '';

                  if (name.trim().isEmpty) {
                    return 'Por favor, insira uma descrição do produto';
                  }

                  if (name.trim().length < 10) {
                    return 'Descrição muito pequena, por favor, insira uma descrição maior';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
