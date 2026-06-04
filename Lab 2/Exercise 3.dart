// Hàm thông thường (Normal syntax)
double calculateBonus(double score) {
  return score * 10;
}

// Hàm mũi tên (Arrow syntax)
int square(int x) => x * x;

void main() {
  print("--- Exercise 3 Output ---");

  // 1. Cấu trúc if/else kiểm tra điểm số
  double studentScore = 85.5;
  if (studentScore >= 80) {
    print("Xếp loại: Xuất sắc");
  } else if (studentScore >= 50) {
    print("Xếp loại: Đạt");
  } else {
    print("Xếp loại: Chưa đạt");
  }

  // 2. Cấu trúc Switch case cho ngày trong tuần
  int dayOfWeek = 3;
  switch (dayOfWeek) {
    case 1: print("Hôm nay là Thứ Hai"); break;
    case 3: print("Hôm nay là Thứ Tư"); break;
    case 7: print("Hôm nay là Chủ Nhật"); break;
    default: print("Ngày không xác định");
  }

  // 3. Vòng lặp duyệt qua collection (for, for-in, forEach)
  List<String> fruits = ['Táo', 'Chuối', 'Cam'];

  print("-> Sử dụng vòng lặp for cơ bản:");
  for (int i = 0; i < fruits.length; i++) {
    print("Vị trí $i: ${fruits[i]}");
  }

  print("-> Sử dụng vòng lặp for-in:");
  for (var fruit in fruits) {
    print("Quả: $fruit");
  }

  print("-> Sử dụng forEach():");
  fruits.forEach((fruit) => print("forEach: $fruit"));

  // 4. Gọi hàm normal và arrow syntax
  print("Điểm thưởng: ${calculateBonus(studentScore)}");
  print("Bình phương của 5 là: ${square(5)}");
}