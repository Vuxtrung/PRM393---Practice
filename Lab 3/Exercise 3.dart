import 'dart:async';

void main() async {
  print("--- Lab 3 - Exercise 3 Output ---");

  print("Thứ tự 1: Tiến trình chính (Main Thread) bắt đầu chạy");

  Future(() {
    print("Thứ tự 4: Hành động trong Event Queue (Future) được thực thi");
  });

  scheduleMicrotask(() {
    print("Thứ tự 3: Hành động trong Microtask Queue được thực thi");
  });

  print("Thứ tự 2: Tiến trình chính hoàn thành các câu lệnh đồng bộ");

  await Future.delayed(Duration(milliseconds: 300));
}