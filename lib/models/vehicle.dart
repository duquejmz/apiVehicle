class Vehicle {
  final String id;
  final String plate; 
  final String color;
  final int model;

  Vehicle({
    required this.id, 
    required this.plate, 
    required this.color, 
    required this.model
  });

// Mapear los datos json
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '', 
      plate: json['plate'] ?? '', 
      color: json ['color'] ?? '', 
      model: json['model'] ?? 0,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      '_id': id,
      'plate': plate,
      'color': color,
      'model': model,
    };
  }
  
}