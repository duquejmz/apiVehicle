import 'dart:ffi';

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/vehicle.dart';

class ListVehiclesScreen  extends StatefulWidget {

  const ListVehiclesScreen({super.key});

  @override
  State<ListVehiclesScreen> createState() => _ListVehiclesScreenState();
}

class _ListVehiclesScreenState extends State<ListVehiclesScreen> {
  final ApiService apiService = ApiService();

  void _registerVehicle(String plate, String color, int model) async {
    try {
      await apiService.createVehicle(plate, color, model);
      print('Vehiculo creado');
    } catch (e) {
      print(e);
    }
  }

  void showRegisterModalVehicle(){

    final TextEditingController _plateController = TextEditingController();
    final TextEditingController _colorController = TextEditingController();
    final TextEditingController _modelController = TextEditingController();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar vehiculo'),
          content: SingleChildScrollView(
            child: Column(children: [
            TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(
                hintText: 'Placa', 
                labelText: 'Ingresar placa', 
                icon: Icon(Icons.numbers)),
            ),
            TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                hintText: 'Color', 
                labelText: 'Ingresar color', 
                icon: Icon(Icons.colorize)),
            ),
            TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                hintText: 'Modelo', 
                labelText: 'Ingresar modelo', 
                icon: Icon(Icons.car_rental)),
            ),
          ],
            ),
          ),
          actions: [
            ElevatedButton(onPressed: () {
              final _plate = _plateController.text.trim();
              final _color = _colorController.text.trim();
              final _model = int.parse(_modelController.text.trim());
              
              print('$_plate' '$_color' '$_model');
              _registerVehicle(_plate, _color, _model);

            }, child: Text('Registrar')),
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('Cancelar'))
          ], 
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Lista de Vehiculos"))),
      body: FutureBuilder<List<Vehicle>>(
        future: apiService.getVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          final vehicles = snapshot.data!;
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle.plate),
                subtitle: Text('${vehicle.color} - ${vehicle.model}'),
                onTap: () {
                  Navigator.pushNamed(context, '/detail', arguments: vehicle.id);
                },
              );
            },
          );
        }
      },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showRegisterModalVehicle();
        }
        ),
    );
  }
}