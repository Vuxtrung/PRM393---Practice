void main() {
  // 1. Khai báo các biến với kiểu dữ liệu cơ bản
  int age = 21;
  double gpa = 3.8;
  String name = "Nguyễn Văn A";
  bool isStudent = true;

  // 2. Sử dụng print() và string interpolation ($var, ${expr}) để hiển thị
  print("--- Exercise 1 Output ---");
  print("Tên sinh viên: $name");
  print("Tuổi: $age tuổi");
  print("Điểm GPA tích lũy: $gpa");
  print("Trạng thái sinh viên: $isStudent");
  print("Tuổi vào năm sau: ${age + 1}");
}