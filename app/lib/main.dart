import 'package:flutter/material.dart';
import 'package:app/models/grocery_items.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const MyHomePage(title: 'Grocery List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final storage = GetStorage();
  List<GroceryItem> groceryList = [];

  @override
  void initState() {
    super.initState();
    final rawList = storage.read('groceryList');
    if (rawList != null) {
      groceryList =
          List<Map>.from(rawList)
              .map(
                (item) => GroceryItem.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
    }
  }

  void _addItemToList(GroceryItem item) {
    setState(() {
      groceryList.add(item);
      _saveList();
    });
  }

  void _saveList() {
    final jsonList = groceryList.map((item) => item.toJson()).toList();
    storage.write('groceryList', jsonList);
  }

  void _markAsDone(int index, String name, bool? value) {
    setState(() {
      groceryList[index].isDone = value ?? false;

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          groceryList.removeWhere((item) => item.name == name);
          _saveList();
        });
      });
    });
  }

  String _getIconPath(String name) {
    switch (name.toLowerCase()) {
      case 'apple':
        return 'assets/icons/apples.png';
      case 'milk':
        return 'assets/icons/milk.png';
      case 'olives':
        return 'assets/icons/olives.png';
      case 'bread':
        return 'assets/icons/bread.png';
      case 'cheese':
        return 'assets/icons/cheese.png';
      case 'cucumbers':
        return 'assets/icons/cucumbers.png';
      case 'eggs':
        return 'assets/icons/eggs.png';
      case 'meat':
        return 'assets/icons/meat.png';
      case 'medicine':
        return 'assets/icons/medicine.png';
      case 'nuts':
        return 'assets/icons/nuts.png';
      case 'snack':
        return 'assets/icons/snack.png';
      case 'tomatoes':
        return 'assets/icons/tomatoes.png';
      case 'water':
        return 'assets/icons/water.png';
      case 'yogurt':
        return 'assets/icons/yogurt.png';
      default:
        return 'assets/icons/vegetables.png';
    }
  }

  void _onAddItemPressed() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true, // Tap outside to close
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: const Color.fromARGB(255, 241, 241, 241),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: qtyController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: const Color.fromARGB(255, 241, 241, 241),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final qty = qtyController.text.trim();

                    _addItemToList(
                      GroceryItem(
                        name: name,
                        qty: qty,
                        iconPath: _getIconPath(name),
                        isDone: false,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check),
                  label: Text('Add to List', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 60, 196, 182),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Image.asset('assets/icons/cart.png', height: 35, width: 35),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _onAddItemPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 217, 244, 236),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: const Color.fromARGB(255, 2, 175, 123),
                      size: 28,
                      weight: 23,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Item',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 70, 103, 93),
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child:
                    groceryList.isEmpty
                        ? Center(child: Text("No items yet!"))
                        : ListView.builder(
                          itemCount: groceryList.length,
                          itemBuilder: (context, index) {
                            final item = groceryList[index];
                            return Column(
                              children: [
                                GroceryItemTile(
                                  name: item.name,
                                  quantity: item.qty,
                                  iconPath: item.iconPath,
                                  isChecked: item.isDone,
                                  onChanged:
                                      (value) =>
                                          _markAsDone(index, item.name, value),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// todo: export below into a file
class GroceryItemTile extends StatelessWidget {
  final String name;
  final String quantity;
  final String iconPath;
  final bool isChecked;
  final Function(bool?) onChanged;

  const GroceryItemTile({
    super.key,
    required this.name,
    required this.quantity,
    required this.iconPath,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(iconPath, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '($quantity)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Checkbox(
            value: isChecked,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
