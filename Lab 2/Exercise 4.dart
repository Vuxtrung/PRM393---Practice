// 1. Tạo lớp cha Car có thuộc tính và phương thức
class Car {
  String brand;
  Car(this.brand);

  // 2. Tạo một Named constructor
  Car.named(this.brand);

  void drive() {
    print("Xe ô tô nhãn hiệu $brand đang chạy.");
  }
}

// 3. Tạo lớp con ElectricCar kế thừa từ Car
class ElectricCar extends Car {
  int batteryCapacity;
  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  @override
  void drive() {
    print("Xe điện $brand đang chạy êm ái với dung lượng pin $batteryCapacity kWh.");
  }
}

void main() {
  print("--- Exercise 4 Output ---");

  // 4. Khởi tạo các đối tượng và in kết quả
  Car myNormalCar = Car("Toyota");
  myNormalCar.drive();

  Car myNamedCar = Car.named("Honda");
  myNamedCar.drive();

  ElectricCar myTesla = ElectricCar("Tesla Model Y", 75);
  myTesla.drive();
}