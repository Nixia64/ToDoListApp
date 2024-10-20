class Category {
  int? id;
  late String name;
  late int count;

  Category({this.id, required this.name, this.count = 0});

  Map<String, dynamic> toMap() => {
    'id' : id,
    'name' : name,
    'count' : count
  };

  Category.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
  }

  @override
  String toString() {
    return name;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Category && runtimeType == other.runtimeType && id == other.id;
  @override
  int get hashCode => id.hashCode;
}