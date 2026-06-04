import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  final List<String> movies = ['Avatar', 'Inception', 'Interstellar', 'Joker'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise 3 - Layout Demo')),
      body: Column( // Sử dụng Column cho các section dọc [cite: 38]
        children: [
          // Thêm spacing dùng Padding [cite: 39]
          Padding(
            padding: const EdgeInsets.all(16.0), // Spacing đồng nhất [cite: 41]
            child: Text(
              'Now Playing',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Sử dụng ListView.builder hiển thị danh sách [cite: 40]
          Expanded( 
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Spacing đồng nhất [cite: 41]
                  child: ListTile(
                    leading: CircleAvatar(child: Text(movies[index][0])),
                    title: Text(movies[index]),
                    subtitle: Text('Sample description'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}