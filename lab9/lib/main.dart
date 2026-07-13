import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// 1. MODEL LAYER
class LocalItem {
  final String id;
  final String name;
  final String description;

  LocalItem({required this.id, required this.name, required this.description});

  factory LocalItem.fromJson(Map<String, dynamic> json) {
    return LocalItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description};
}

// 2. SERVICE LAYER
class StorageService {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/local_items.json');
  }

  Future<List<LocalItem>> loadItems() async {
    try {
      final file = await _getLocalFile();
      String jsonString;
      if (await file.exists()) {
        jsonString = await file.readAsString();
      } else {
        try {
          jsonString = await rootBundle.loadString('assets/data/items.json');
        } catch (_) {
          jsonString = '[]';
        }
        await file.writeAsString(jsonString);
      }
      final List<dynamic> jsonResponse = json.decode(jsonString);
      return jsonResponse.map((sec) => LocalItem.fromJson(sec)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveItems(List<LocalItem> items) async {
    final file = await _getLocalFile();
    final String jsonString = json.encode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}

// 3. MAIN & UI LAYER
void main() {
  runApp(const MaterialApp(
    home: LocalCrudScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LocalCrudScreen extends StatefulWidget {
  const LocalCrudScreen({super.key});

  @override
  State<LocalCrudScreen> createState() => _LocalCrudScreenState();
}

class _LocalCrudScreenState extends State<LocalCrudScreen> {
  final StorageService _storageService = StorageService();
  List<LocalItem> _allItems = [];
  List<LocalItem> _filteredItems = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    _searchController.addListener(_filterList);
  }

  void _loadLocalData() async {
    final data = await _storageService.loadItems();
    setState(() {
      _allItems = data;
      _filteredItems = data;
    });
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query))
          .toList();
    });
  }

  void _syncToStorage() async {
    await _storageService.saveItems(_allItems);
    _filterList();
  }

  void _showItemForm({LocalItem? existingItem}) {
    final nameController = TextEditingController(text: existingItem?.name ?? '');
    final descController = TextEditingController(text: existingItem?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingItem == null ? 'Thêm mới dữ liệu' : 'Chỉnh sửa dữ liệu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên mục')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Mô tả')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                if (existingItem == null) {
                  _allItems.add(LocalItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descController.text,
                  ));
                } else {
                  final index = _allItems.indexWhere((e) => e.id == existingItem.id);
                  if (index != -1) {
                    _allItems[index] = LocalItem(
                      id: existingItem.id,
                      name: nameController.text,
                      description: descController.text,
                    );
                  }
                }
                _syncToStorage();
                Navigator.pop(context);
              }
            },
            child: const Text('Xác nhận'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9: Local JSON Database')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Tìm kiếm dữ liệu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(item.name, fontWeight: FontWeight.bold),
                        subtitle: Text(item.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showItemForm(existingItem: item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _allItems.removeWhere((e) => e.id == item.id);
                                _syncToStorage();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}