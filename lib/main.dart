import 'package:flutter/material.dart';
import 'package:vehicle_app/screens/list_vehicles_screen.dart';

void main(List<String> args) {
  runApp(Principal());
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Vehcicle',
      home: ListVehiclesScreen(),
    );
  }
}