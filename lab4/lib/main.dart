import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CoreWidgetsDemo(),       
      // home: InputControlsDemo(),     
      // home: LayoutDemo(),           
      // home: AppStructureThemeDemo(),
    );
  }
}