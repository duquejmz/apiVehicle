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

  List<Vehicle> vehicles = [];

   @override
   void initState() {
     super.initState();
     loadVehicles();
  }

  Future<void> loadVehicles() async {
    try {
      final fetchedVehicles = await apiService.getVehicles();
      setState(() {
        vehicles = fetchedVehicles;  
      });
    } catch (e) {
        print('Error cargando el listado de vehiculos');
    }
  }

  void _registerVehicle(String plate, String color, int model) async {
    try {
      await apiService.createVehicle(plate, color, model);
      await loadVehicles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehiculo creado exitosamente'))
        );
        Navigator.of(context).pop();
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sucedio un problema creando el vehiculo'))
        );
    }
  }

  void _editVehicle(String id, String plate, String color, int model) async {
    try {
      await apiService.updateVehicle(id, Vehicle(id: id, plate: plate, color: color, model: model));
      await loadVehicles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehiculo actualizado exitosamente'))
        );
        Navigator.of(context).pop();
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sucedio un problema actualizando el vehiculo'))
        );
    }
  }

  void showDeleteModalVehicle(String id, String plate, String color, int model) async {
    final confirmDelete = await showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminación del vehiculo'),
          content: Text('¿Estas seguro de eliminar el registro?'),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(false);
                }, 
                label: Text('Cancelar'),
                icon: Icon(Icons.cancel),
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 171, 217),
                ),
              ),

              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(false);
                }, 
                label: Text('Confirmar'),
                icon: Icon(Icons.confirmation_number),
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 242, 215, 238),
                ),
              ),
          ],
        );
      },
    );
    if (confirmDelete == true) {
      try {
        await apiService.deleteVehicle(id);
        loadVehicles();
      } catch (e) {
        print('No se pudo eliminar el objeto');
      }
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
              
              if (_plate.isEmpty || _color.isEmpty || _model == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Por favor, complete todos los campos correctamente')),
                );
                return;
              }
              
              // Llama a la función de registro con los datos validados.
              _registerVehicle(_plate, _color, _model);
            },
            child: Text('Registrar'),),
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('Cancelar'))
            ], 
        );
      }
    );
  }

  void showEditModalVehicle(String id, String plate, String color, int model){

    final TextEditingController _plateController = TextEditingController();
    final TextEditingController _colorController = TextEditingController();
    final TextEditingController _modelController = TextEditingController();

    _plateController.text = plate;
    _colorController.text = color;
    _modelController.text = model.toString();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar vehiculo'),
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
              _editVehicle(id, _plate, _color, _model);
              Navigator.of(context).pop();

            }, child: Text('Guardar')),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  IconButton(
                    onPressed: () {
                      showEditModalVehicle(vehicle.id, vehicle.plate , vehicle.color, vehicle.model);
                    }, icon: Icon(Icons.edit)),
                  SizedBox(width: 30),
                  IconButton(
                    onPressed: () {
                      showDeleteModalVehicle(vehicle.id, vehicle.plate, vehicle.color, vehicle.model);
                    }, 
                    icon: Icon(Icons.delete))
                ]
                )
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