import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokemons = [];
  List<dynamic> types = [];
  List<String> allTypes = [];

  String lorem =
      'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor';
  @override
  void initState() {
    fetchPokemons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon'),
        centerTitle: true,
        leading: IconButton(
          icon: Image.network(
              'https://cdn.icon-icons.com/icons2/896/PNG/512/pokemon_go_play_game_cinema_film_movie_icon-icons.com_69163.png'),
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = pokemons[index];
          final name = pokemon['name'];
          final url = pokemon['url'];
          return Card(
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${index + 1}.png'),
                ),
              ),
              title: Text(name),
              subtitle: Text(
                lorem,
                maxLines: 3,
              ),
              trailing: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: const CircleAvatar(
                  backgroundColor: Colors.green,
                  //backgroundColor: getColor(allTypes[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //Funcion para consultar la lista de pokemones
  void fetchPokemons() async {
    print('Llamando a la api de pokemons');
    const url = 'https://pokeapi.co/api/v2/pokemon/';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      pokemons = json['results'];
    });
    print('Llamado a la api de pokemons completado');
    //pokemonDetails(pokemons);
  }

// Funcion para consultar el detalle de cada pokemon de la lista
  void pokemonDetails(List<dynamic> pokemons) async {
    for (var p in pokemons) {
      fetchPokemonsType(p['url']);
    }
    //print('Imprimiendo los tipos');
    ///print(allTypes);
  }

  //Funcion para consultar el typo de pokemon
  void fetchPokemonsType(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      types = json['types'];
    });
    for (var t in types) {
      allTypes.add(t['type']['name'].toString());
      break;
    }
  }

  // Funcion para definir el color del pokemon
  Color getColor(String tipo) {
    if (tipo == 'water') {
      return Colors.blue;
    } else if (tipo == 'grass') {
      return Colors.green;
    } else if (tipo == 'fire') {
      return Colors.red;
    } else {
      return Colors.brown;
    }
  }
}
