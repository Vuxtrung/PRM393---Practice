void main() {
  print("--- Exercise 2 Output ---");

  // 1. Tạo một List số nguyên và sử dụng add(), remove()
  List<int> numbers = [10, 20, 30, 40];
  numbers.add(50);
  numbers.remove(20); 
  print("List sau khi chỉnh sửa: $numbers");

  // 2. Tạo một Set chứa các giá trị duy nhất
  Set<String> roles = {'Admin', 'User', 'Admin'}; 
  print("Set các quyền (duy nhất): $roles");

  // 3. Tạo một Map (key-value) và truy cập phần tử
  Map<String, dynamic> product = {
    'id': 'P01',
    'name': 'Laptop Asus',
    'price': 1500.0
  };
  print("Tên sản phẩm từ Map: ${product['name']}");

  // 4. Sử dụng các toán tử cơ bản
  int a = 15;
  int b = 10;
  bool comparison = (a > b) && (b == 10);
  print("Kết quả so sánh ((a > b) && (b == 10)): $comparison");

  String priceStatus = (product['price'] > 1000) ? "Đắt tiền" : "Giá rẻ";
  print("Trạng thái giá sản phẩm: $priceStatus");
}