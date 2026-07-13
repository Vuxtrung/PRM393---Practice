import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 1. SERVICES LAYER (Auth, API & Notification chung trong file)
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: android));
  }

  static Future<void> show(String title, String body) async {
    const details = AndroidNotificationDetails(
      'auth_chan', 'Auth Notifications',
      importance: Importance.max, priority: Priority.high
    );
    await _plugin.show(0, title, body, const NotificationDetails(android: details));
  }
}

class AuthService {
  static const String _key = "token";
  Future<void> saveSession(String t) async => (await SharedPreferences.getInstance()).setString(_key, t);
  Future<bool> isLoggedIn() async => (await SharedPreferences.getInstance()).containsKey(_key);
  Future<void> logout() async => (await SharedPreferences.getInstance()).remove(_key);
}

class ApiService {
  Future<String?> login(String user, String pass) async {
    try {
      final res = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': user, 'password': pass}),
      );
      if (res.statusCode == 200) return json.decode(res.body)['token'];
      return null;
    } catch (_) {
      return null;
    }
  }
}

// 2. MAIN SYSTEM ENTRY
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Kích hoạt hệ thống LO7 thông báo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 3. NAVIGATION SCREENS LAYER (Splash, Login & Home)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeGuard();
  }

  void _routeGuard() async {
    await Future.delayed(const Duration(seconds: 2));
    bool logged = await AuthService().isLoggedIn();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => logged ? const HomeScreen() : const LoginScreen()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController(text: 'emilys'); // Tài khoản test thật của API
  final _pass = TextEditingController(text: 'emilyspass');
  bool _loading = false;

  void _doLogin() async {
    setState(() => _loading = true);
    String? token = await ApiService().login(_user.text.trim(), _pass.text.trim());
    setState(() => _loading = false);

    if (token != null) {
      await AuthService().saveSession(token);
      await NotificationService.show('Đăng nhập thành công', 'Hệ thống đã đồng bộ trạng thái đăng nhập!');
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Nhập Hệ Thống')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _user, decoration: const InputDecoration(labelText: 'Tài khoản')),
            TextField(controller: _pass, decoration: const InputDecoration(labelText: 'Mật khẩu'), obscureText: true),
            const SizedBox(height: 20),
            _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _doLogin, child: const Text('Đăng nhập'))
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ - Lab 10'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () async {
            await AuthService().logout();
            if (context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            }
          })
        ],
      ),
      body: const Center(child: Text('Chào mừng bạn! Trạng thái đăng nhập đã được ghi nhớ.', style: TextStyle(fontSize: 16))),
    );
  }
}