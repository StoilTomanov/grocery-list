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
      home: const MyHomePage(title: 'Списък за пазаруване'),
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
  final Set<String> _markedDone = {};
  final Set<String> _fadingItems = {};

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
      _markedDone.add(name);
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _fadingItems.add(name);
      });

      Future.delayed(Duration(milliseconds: 400), () {
        setState(() {
          groceryList.removeWhere((item) => item.name == name);
          _fadingItems.remove(name);
          _markedDone.remove(name);
          _saveList();
        });
      });
    });
  }

  String _getIconPath(String name) {
    if (name.toLowerCase() == 'ябълки') {
      return 'assets/icons/apples.png';
    } else if (name.toLowerCase() == 'мляко') {
      return 'assets/icons/milk.png';
    } else if (name.toLowerCase() == 'кашкавал') {
      return 'assets/icons/cheese.png';
    } else if (name.toLowerCase() == 'маслини') {
      return 'assets/icons/olives.png';
    } else if (name.toLowerCase() == 'хляб') {
      return 'assets/icons/bread.png';
    } else if (name.toLowerCase() == 'сирене') {
      return 'assets/icons/cheese.png';
    } else if (name.toLowerCase() == 'краставици') {
      return 'assets/icons/cucumbers.png';
    } else if (name.toLowerCase() == 'яйца') {
      return 'assets/icons/eggs.png';
    } else if (name.toLowerCase() == 'месо') {
      return 'assets/icons/meat.png';
    } else if ([
      'дуфалак',
      'атаракс',
      'продуктал',
      'ко-валсакор',
      'ноотропил',
      'русокард',
      'мента глог и валериян',
      'стрезам',
    ].contains(name.toLowerCase())) {
      return 'assets/icons/medicine.png';
    } else if ([
      'ядки',
      'бадеми',
      'фъстъци',
      'кашу',
    ].contains(name.toLowerCase())) {
      return 'assets/icons/nuts.png';
    } else if (['кроки', 'пуканки'].contains(name.toLowerCase())) {
      return 'assets/icons/snack.png';
    } else if (name.toLowerCase() == 'домати') {
      return 'assets/icons/tomatoes.png';
    } else if (name.toLowerCase() == 'вода') {
      return 'assets/icons/water.png';
    } else if (name.toLowerCase() == 'кисело мляко') {
      return 'assets/icons/yogurt.png';
    }

    return 'assets/icons/vegetables.png';
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
                  'Добави продукт',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Име на продукт',
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
                      'Количество',
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
                        qty: qty == '' ? '1' : qty,
                        iconPath: _getIconPath(name),
                        isDone: false,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.check),
                  label: Text(
                    'Добави към списък',
                    style: TextStyle(fontSize: 16),
                  ),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Image.asset('assets/icons/cart.png', height: 35, width: 35),
            ],
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
                      'Добави продукт',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 70, 103, 93),
                        fontSize: 20,
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
                        ? Center(child: Text("Все още няма продукти"))
                        : ListView.builder(
                          itemCount: groceryList.length,
                          itemBuilder: (context, index) {
                            final item = groceryList[index];
                            final isFading = _fadingItems.contains(item.name);
                            final isDone = item.isDone;

                            return AnimatedSlide(
                              offset:
                                  isFading
                                      ? const Offset(-1.0, 0)
                                      : Offset.zero,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              child: AnimatedOpacity(
                                opacity: isFading ? 0.0 : 1.0,
                                duration: Duration(milliseconds: 400),
                                child: Column(
                                  children: [
                                    GroceryItemTile(
                                      name: item.name,
                                      quantity: item.qty,
                                      iconPath: item.iconPath,
                                      isChecked: isDone,
                                      onChanged:
                                          (value) => _markAsDone(
                                            index,
                                            item.name,
                                            value,
                                          ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
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
