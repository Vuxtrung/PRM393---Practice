import 'dart:async';

void main() async {
  print("--- Lab 3 - Exercise 4 Output ---");

  // 1. Tạo một stream phát ra chuỗi số từ 1 đến 5
  Stream<int> numbersStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  print("Bắt đầu biến đổi và lọc dữ liệu trên Stream:");

  // 2. Áp dụng map() để bình phương giá trị và where() để lọc lấy số chẵn
  await numbersStream
      .map((value) => value * value) 
      .where((value) => value % 2 == 0)
      .listen((resultValue) {
        // 3. Lắng nghe và in các phần tử thỏa mãn điều kiện ra màn hình
        print("Dữ liệu nhận được sau bộ lọc Stream: $resultValue");
      }).asFuture();
} 