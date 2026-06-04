class Settings {
  static final Settings _cachedInstance = Settings._internalConstructor();

  // 1. Tạo một Private constructor ngăn không cho khởi tạo tự do từ bên ngoài
  Settings._internalConstructor();

  // 2. Tạo một Factory constructor luôn trả về duy nhất thực thể đã lưu trữ trong bộ nhớ cache
  factory Settings() {
    return _cachedInstance;
  }
  String themeMode = "Dark-Mode";
}

void main() {
  print("--- Lab 3 - Exercise 5 Output ---");

  Settings configA = Settings();
  Settings configB = Settings();
  configA.themeMode = "Light-Mode";

  // 3. Sử dụng hàm identical(a, b) để kiểm tra xem hai biến có trỏ chung vào một ô nhớ hay không
  bool checkSameObject = identical(configA, configB);
  
  print("Giá trị cấu hình của configB: ${configB.themeMode}"); 
  print("Kết quả kiểm tra identical(configA, configB): $checkSameObject");
  
  if (checkSameObject) {
    print("=> Xác nhận: Cả hai biến đều tham chiếu tới cùng 1 đối tượng duy nhất (Mẫu Singleton hoạt động chuẩn xác)!");
  }
}