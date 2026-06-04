import 'dart:async';

Future<String> fetchUserData() async {
  print("Bắt đầu tải dữ liệu từ máy chủ...");
  await Future.delayed(Duration(milliseconds: 1500));
  return "Dữ liệu người dùng đã sẵn sàng!";
}

void main() async {
  print("--- Exercise 5 Output ---");

  // 1. Thực hành toán tử null-safety (?, ??, !)
  String? nullableName;
  print("Tên người dùng: ${nullableName ?? 'Khách vãng lai'}");
  
  nullableName = "John Doe";
  print("Độ dài tên: ${nullableName!.length}");

  // 2. Gọi hàm async/await và Future.delayed
  String result = await fetchUserData();
  print(result);

  // 3. Tạo một Stream số nguyên đơn giản và lắng nghe (listen) giá trị phát ra
  print("Bắt đầu khởi tạo Stream phát số tự động:");
  Stream<int> counterStream = Stream.periodic(Duration(milliseconds: 400), (count) => count + 1).take(3);

  await counterStream.listen((value) {
    print("Stream phát ra giá trị số: $value");
  }).asFuture();
}