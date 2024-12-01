import 'dart:convert'; // Para manejar JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Para realizar solicitudes HTTP
import 'pokemon_detail_page.dart'; // Importar la página de detalles

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List pokedex = []; // Lista completa de Pokémon
  List filteredPokedex = []; // Lista filtrada para el buscador
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPokedex(); // Cargar el JSON desde la web
    searchController.addListener(() {
      filterPokemon(); // Escuchar cambios en el buscador
    });
  }

  Future<void> loadPokedex() async {
    const String url =
        'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';

    try {
      final response = await http.get(Uri.parse(url)); // Realiza la solicitud HTTP
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decodifica el JSON
        setState(() {
          pokedex = data["pokemon"]; // Carga los datos en la lista
          filteredPokedex = pokedex; // Inicializa la lista filtrada
        });
      } else {
        print('Error al cargar datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }

  void filterPokemon() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPokedex = pokedex
          .where((pokemon) => pokemon["name"].toLowerCase().contains(query))
          .toList();
    });
  }

  Color color(index) {
    switch (filteredPokedex[index]["type"][0]) {
      case "Grass":
        return Colors.greenAccent;
      case "Fire":
        return Colors.redAccent;
      case "Water":
        return Colors.blue;
      case "Poison":
        return Colors.deepPurpleAccent;
      case "Electric":
        return Colors.amber;
      case "Rock":
        return Colors.grey;
      case "Ground":
        return Colors.brown;
      case "Psychic":
        return Colors.indigo;
      case "Fighting":
        return Colors.orange;
      case "Bug":
        return Colors.lightGreenAccent;
      case "Ghost":
        return Colors.deepPurple;
      case "Normal":
        return Colors.white12;
      default:
        return Colors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 216, 134, 134), // Fondo más claro
              Color.fromARGB(255, 197, 148, 148),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: pokedex.isNotEmpty
            ? Column(
                children: [
                  // Barra de búsqueda y título
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        const Text(
                          "Pokedex",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24, // Ajusta el tamaño del texto
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Buscar...",
                              hintStyle: const TextStyle(fontSize: 14),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(Icons.search, size: 20),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Lista de Pokémon
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 5,
                      ),
                      itemCount: filteredPokedex.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PokemonDetailPage(
                                    pokemon: filteredPokedex[index],
                                  ),
                                ),
                              );
                            },
                            child: SafeArea(
                              child: Stack(
                                children: [
                                  Container(
                                    width: width,
                                    margin: const EdgeInsets.only(top: 80),
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 90,
                                          left: 15,
                                          child: Text(
                                            filteredPokedex[index]["num"],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 130,
                                          left: 15,
                                          child: Text(
                                            filteredPokedex[index]["name"],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 170,
                                          left: 15,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            child: Text(
                                              filteredPokedex[index]["type"][0],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: color(index),
                                                shadows: [
                                                  BoxShadow(
                                                    color: color(index),
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 1.0,
                                                    blurRadius: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      "assets/images/${filteredPokedex[index]["num"]}.png",
                                      height: 180,
                                      fit: BoxFit.fitHeight,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Colors.red,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
