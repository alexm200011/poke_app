import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poke_app/models/pokemon_details.dart';

void main() => runApp(const DetailScreen(
      url: '',
    ));

class DetailScreen extends StatefulWidget {
  final String url;
  const DetailScreen({required this.url});

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  PokemonDetail? details;
  String _parametro = '';

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (details == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.5;
    return AlertDialog(
      title: Text(details!.name.toString()),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        child: Column(
          children: [
            Image.network(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${details!.id}.png'),
            DataTable(columns: const [
              DataColumn(label: Text('Etiqueta')),
              DataColumn(label: Text('Info')),
            ], rows: [
              DataRow(cells: [
                const DataCell(Text('Orden')),
                DataCell(Text(details!.order.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Altura')),
                DataCell(Text(details!.height.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Peso')),
                DataCell(Text(details!.weight.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Experiencia')),
                DataCell(Text(details!.experience.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Nombre')),
                DataCell(Text(details!.name.toString())),
              ]),
            ]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Aceptar'),
        )
      ],
    );
  }

  Future<void> loadDetails() async {
    _parametro = widget.url;
    final response = await http.get(Uri.parse(_parametro));
    if (response.statusCode == 200) {
      setState(() {
        final dynamic pokemonDetailResult = jsonDecode(response.body);
        details = PokemonDetail(
            height: pokemonDetailResult['height'],
            experience: pokemonDetailResult['base_experience'],
            weight: pokemonDetailResult['weight'],
            name: pokemonDetailResult['name'],
            id: pokemonDetailResult['id'],
            order: pokemonDetailResult['order']);

        log('Se ha consultado la info de pokemons correctamente');
      });
    } else {
      throw Exception('Error al obtener los detalles del pokemon');
    }
  }
}
