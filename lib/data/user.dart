import 'package:meta/meta.dart';

class User {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  int id;

  String bytes;

  User({
    @required this.bytes,
  });

  Map<String, dynamic> toMap() {
    return {
      'bytes': bytes,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      bytes: map['bytes'],
    );
  }
}
