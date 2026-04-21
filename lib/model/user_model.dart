class UserModel{
  static UserModel? currentUser;
  List<String> favouriteEventsIds;
  String id;
  String name;
  String email;
  UserModel({required this.id, required this.name, required this.email, required this.favouriteEventsIds});


  UserModel.fromJson(Map<String, dynamic> json): this(
    favouriteEventsIds: (json['favouriteEventsIds'] as List<dynamic>).cast<String>(),
    id: json["id"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic>toJson()=>{
    'favouriteEventsIds': favouriteEventsIds,
    "id":id,
    "name":name,
    "email": email
  };
}