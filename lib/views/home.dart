import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poke_app/models/pokemon.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> pokemons = [];

  String lorem =
      'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor';
  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Pokémon', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Image.network(
              'https://cdn-icons-png.flaticon.com/512/188/188987.png'),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.width * 0.05),
        child: ListView.builder(
          itemCount: pokemons.length,
          itemBuilder: (context, index) {
            final pokemon = pokemons[index];
            final name = pokemon.name.toString();
            return Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      child: Image.network(
                        fit: BoxFit.cover,
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${index + 1}.png',
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
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Image.network(
                            'https://cdn.icon-icons.com/icons2/896/PNG/512/pokemon_go_play_game_cinema_film_movie_icon-icons.com_69163.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  //Funcion para consultar la lista de pokemones
  Future<void> fetchPokemons() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon'));
    if (response.statusCode == 200) {
      final List<dynamic> pokemonListJson =
          jsonDecode(response.body)['results'];
      setState(() {
        pokemons =
            pokemonListJson.map((json) => Pokemon.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load pokemon list');
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
