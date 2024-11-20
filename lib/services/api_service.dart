// permite trabajar con datos json
import 'dart:convert';
// Para poder realizar peticiones http
import 'package:http/http.dart' as http;
import 'package:vehicle_app/models/vehicle.dart';

class ApiService {
  static const String baseUrl = "https://api-2821726-m4st.onrender.com/api/vehicle";

  // Listar todos los vehiculos

  Future<List<Vehicle>> getVehicles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Primero se recibe un mapa
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      // Debo de convertirlo a un jsonData
      final List<dynamic> vehiclesData = jsonData['vehicles'];

      return vehiclesData.map((item) => Vehicle.fromJson(item)).toList();
    }
    else {
      throw Exception("Error al cargar vehículos");
    }
  }

  // Registrar un vehículo
  Future<void> createVehicle(String placa, String color, int modelo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'plate' : placa,
        'color': color,
        'model': modelo
      })
      );
      if (response.statusCode != 200) {
        throw Exception("Error al registrar vehículo");
        }
    }

    // Modificar un vehículo
    Future<void> updateVehicle(String id, Vehicle vehicle) async {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(vehicle.toJson()),
        );
        if (response.statusCode != 200) {
          throw Exception("Error al modificar vehículo");
          }
      }

      Future<void> deleteVehicle(String id) async {
        final response = await http.delete(Uri.parse('$baseUrl/$id'));
        if (response.statusCode != 200) {
          throw Exception("Error al eliminar vehículo");
          }
      }
  }