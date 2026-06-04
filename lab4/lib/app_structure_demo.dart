import 'package:flutter/material.dart';

// Đóng vai trò là Widget root cho bài 4
class AppStructureThemeDemo extends StatefulWidget {
  @override
  _AppStructureThemeDemoState createState() => _AppStructureThemeDemoState();
}

class _AppStructureThemeDemoState extends State<AppStructureThemeDemo> {
  bool _isDarkMode = false; // Trạng thái chuyển đổi giao diện [cite: 51]

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Cấu hình Theme sáng [cite: 50]
      darkTheme: ThemeData.dark(), // Cấu hình Theme tối [cite: 50]
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Chuyển đổi Dark Mode [cite: 51]
      home: Scaffold( // Cấu trúc Scaffold [cite: 45]
        appBar: AppBar( // AppBar [cite: 47]
          title: Text('Exercise 4 - App Structure'),
          actions: [
            Row(
              children: [
                Text('Dark'),
                Switch(
                  value: _isDarkMode,
                  onChanged: (val) => setState(() => _isDarkMode = val),
                ),
              ],
            )
          ],
        ),
        body: Center( // Body [cite: 48]
          child: Text('This is a simple screen with theme toggle.'),
        ),
        floatingActionButton: FloatingActionButton( // FloatingActionButton [cite: 49]
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}