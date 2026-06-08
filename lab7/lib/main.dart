import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignupFormScreen(),
  ));
}
// BƯỚC 1: TẠO STATEFUL WIDGET CHO FORM (Lab 7.1)
class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends State<SignupFormScreen> {
  // GlobalKey để quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers để lấy dữ liệu từ các ô nhập
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // LAB 7.3: QUẢN LÝ FOCUS (ĐIỀU HƯỚNG BÀN PHÍM)
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // Biến trạng thái để hiển thị vòng xoay loading khi đang check Async
  bool _isLoading = false;

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi tắt màn hình
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  // LAB 7.4: MÔ PHỎNG KIỂM TRA EMAIL BẤT ĐỒNG BỘ (ASYNC VALIDATION)
  Future<bool> _isEmailTaken(String email) async {
    // Giả lập độ trễ mạng (1.5 giây)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Nếu email bắt đầu bằng từ "taken", coi như đã tồn tại trên Server
    if (email.trim().toLowerCase().startsWith('taken')) {
      return true;
    }
    return false;
  }

  // Hàm xử lý khi bấm nút Submit
  void _submitForm() async {
    // 1. Kích hoạt toàn bộ Validator đồng bộ (Lab 7.2)
    if (_formKey.currentState!.validate()) {
      
      // 2. Chuyển sang trạng thái Loading để check Async (Lab 7.4)
      setState(() {
        _isLoading = true;
      });

      // Ẩn bàn phím
      FocusScope.of(context).unfocus();

      // Gọi hàm check email giả lập
      bool emailTaken = await _isEmailTaken(_emailController.text);

      setState(() {
        _isLoading = false;
      });

      // Kiểm tra BuildContext còn tồn tại hay không trước khi hiện SnackBar
      if (!mounted) return;

      if (emailTaken) {
        // Hiện thông báo lỗi nếu Email bị trùng
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error: This email is already taken!'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Registration Successful, Welcome ${_nameController.text}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bọc ngoài cùng bằng GestureDetector để xử lý chạm ra ngoài -> Ẩn bàn phím (Good UX)
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        // Bọc Form trong SingleChildScrollView để chống tràn viền khi bàn phím hiện lên
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction, // Bật cái này nếu muốn form tự check lỗi ngay khi gõ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  '(Hint: Type "taken@gmail.com" to test server error)',
                  style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

          
                // LAB 7.1 & 7.2: FULL NAME FIELD
      
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next, // Nút "Next" trên bàn phím
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus), // Chuyển con trỏ xuống Email
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // LAB 7.1 & 7.2: EMAIL FIELD   
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an email';
                    }
                    // Email phải có định dạng chứa '@' và '.'
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // LAB 7.1 & 7.2: PASSWORD FIELD (Kiểm tra độ mạnh)
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: true, // Ẩn mật khẩu (dấu chấm tròn)
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    // Dùng Regex kiểm tra xem có chứa ít nhất 1 chữ số hay không
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain at least 1 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // LAB 7.1 & 7.2: CONFIRM PASSWORD FIELD (Kiểm tra trùng khớp)
                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  obscureText: true,
                  textInputAction: TextInputAction.done, // Nút "Done" trên bàn phím
                  onFieldSubmitted: (_) => _submitForm(), // Bấm Done thì chạy hàm Submit
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.verified_user),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password';
                    }
                    // Kiểm tra xem có khớp với ô Password ở trên không
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // NÚT SUBMIT FORM
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm, // Khóa nút khi đang loading
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}