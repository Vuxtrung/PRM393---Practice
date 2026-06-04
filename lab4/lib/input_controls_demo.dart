import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget { // 
  @override
  _InputControlsDemoState createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _rating = 50;
  bool _isActive = false;
  String _genre = 'None';
  DateTime? _selectedDate;

  // Hàm hiển thị DatePicker [cite: 33]
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise 2 - Input Controls')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider [cite: 32]
            Text('Rating (Slider): ${_rating.toInt()}'), // Hiển thị giá trị 
            Slider(
              value: _rating,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => _rating = value),
            ),
            
            // Switch [cite: 32]
            SwitchListTile(
              title: Text('Active (Switch)'),
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value),
            ),

            // RadioListTile [cite: 32]
            Text('Genre (RadioListTile)'),
            RadioListTile<String>(
              title: Text('Action'),
              value: 'Action',
              groupValue: _genre,
              onChanged: (value) => setState(() => _genre = value!),
            ),
            RadioListTile<String>(
              title: Text('Comedy'),
              value: 'Comedy',
              groupValue: _genre,
              onChanged: (value) => setState(() => _genre = value!),
            ),

            // DatePicker Button [cite: 33]
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Open Date Picker'),
            ),
            if (_selectedDate != null)
              Text('Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0]), // Hiển thị giá trị 
          ],
        ),
      ),
    );
  }
}