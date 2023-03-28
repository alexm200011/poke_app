import 'package:flutter/material.dart';
import 'package:poke_app/models/pokemon.dart';

import 'package:flutter/material.dart';

import '../views/detail.dart';

class SearchPokemonDelegate extends SearchDelegate<Pokemon>{
  
  final List<Pokemon> pokemons;
  List<Pokemon> filter = [];
  String lorem =
      'Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor';

  SearchPokemonDelegate(this.pokemons);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
      onPressed: (){
        query = '';
      }, 
      icon: const Icon(Icons.close))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, Pokemon(name: '', url: ''));
      }, 
      icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    filter = pokemons.where((pokemon){
      return pokemon.name!.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.width * 0.05),
        child: ListView.builder(
          itemCount: filter.length,
          itemBuilder: (context, index) {
            final pokemon = filter[index];
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
                      child: GestureDetector(
                        onTap: (){
                          showDialog(context: context, barrierDismissible: false,builder: ((context){
                            return DetailScreen(url: pokemon.url.toString());
                          }));
                        },
                        child: CircleAvatar(
                          child: Image.network(
                              'https://cdn.icon-icons.com/icons2/896/PNG/512/pokemon_go_play_game_cinema_film_movie_icon-icons.com_69163.png'),
                        ),
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
      );
  }
}