class GroceryItem {
  final String name;
  final String qty;
  final String iconPath;
  bool isDone;

  GroceryItem({
    required this.name,
    required this.qty,
    required this.iconPath,
    required this.isDone,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'qty': qty,
    'iconPath': iconPath,
    'isDone': isDone,
  };

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
    name: json['name'],
    qty: json['qty'],
    iconPath: json['iconPath'],
    isDone: json['isDone'],
  );
}
