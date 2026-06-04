import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise 1 - Core Widgets')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Headline Text 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Flutter UI',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // 2. Icon using Material Icons 
            Icon(Icons.movie, size: 100, color: Colors.blue),
            // 3. Image.network() 
            Image.network(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
              height: 200,
            ),
            // 4. Card containing a ListTile 
            Card(
              margin: EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Movie Item'),
                subtitle: Text('This is a sample ListTile inside a Card.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}