class ToDoAttributes{
  static String table = 'todo';
  int? id;
  String? name;
  ToDoAttributes({required this.id,required this.name});
  factory ToDoAttributes.fromMap(Map<String,dynamic> map)
  {
    return ToDoAttributes(
        id: map["id"],
        name: map["name"],
    );
  }
  toMap()=>{
    "id":id,
    "name":name,
  };
}