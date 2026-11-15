class City {
  final String id;
  final String name;
  final String nameUr;

  City({required this.id, required this.name, required this.nameUr});

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      nameUr: map['name_ur'] ?? map['ur'] ?? map['name'] ?? '',
    );
  }
}

class Area {
  final String id;
  final String cityId;
  final String name;
  final String nameUr;

  Area({
    required this.id,
    required this.cityId,
    required this.name,
    required this.nameUr,
  });

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'] ?? '',
      cityId: map['city_id'] ?? map['cityId'] ?? '',
      name: map['name'] ?? '',
      nameUr: map['name_ur'] ?? map['ur'] ?? map['name'] ?? '',
    );
  }
}
