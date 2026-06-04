import 'dart:async';

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(ID: $id, Name: $name, Price: \$$price)';
}

class ProductRepository {
  final List<Product> _productsList = [
    Product(id: 1, name: 'Màn hình Dell', price: 250.0),
  ];

  final _streamController = StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(milliseconds: 500)); 
    return _productsList;
  }
  Stream<Product> liveAdded() => _streamController.stream;

  void addNewProduct(Product product) {
    _productsList.add(product);
    _streamController.sink.add(product);
  }

  void dispose() {
    _streamController.close();
  }
}

void main() async {
  print("--- Lab 3 - Exercise 1 Output ---");
  var repository = ProductRepository();

  repository.liveAdded().listen((newProd) {
    print("[STREAM UPDATE] Có sản phẩm mới vừa được thêm: $newProd");
  });

  var currentProducts = await repository.getAll();
  print("Danh sách sản phẩm ban đầu: $currentProducts");
  repository.addNewProduct(Product(id: 2, name: 'Bàn phím cơ', price: 95.0));
  await Future.delayed(Duration(milliseconds: 200));
  repository.dispose();
}