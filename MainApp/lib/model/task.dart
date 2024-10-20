class Task {
  int? id;
  late String name;
  late bool over;
  late int category_id;

  Task({this.id, required this.name, this.over = false, required this.category_id});

 Map<String, dynamic> toMap() => {
    'id' : id,
    'name' : name,
    'over' : over == true ? 1 : 0,
    'category_id' : category_id
  };

  Task.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    over = json['over'] == 1 ? true : false;
    category_id = json['category_id'];
  }

  @override
  String toString() {
    return name;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Task && runtimeType == other.runtimeType && id == other.id;
  @override
  int get hashCode => id.hashCode;
}