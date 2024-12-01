import 'package:flutter/material.dart';

class PokemonDetailPage extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  bool isFavorite = false; // Para gestionar si es favorito
  TextEditingController commentController = TextEditingController(); // Para capturar comentarios
  List<String> comments = []; // Lista de comentarios
  int? editingIndex; // Índice del comentario que se está editando

  @override
  void initState() {
    super.initState();
    // Cargar los comentarios previos si los tienes guardados (por ejemplo, usando SharedPreferences o Firebase)
  }

  // Método para guardar o actualizar los comentarios
  void addOrUpdateComment(String comment) {
    setState(() {
      if (editingIndex == null) {
        comments.add(comment); // Si no estamos editando, agregar un nuevo comentario
      } else {
        comments[editingIndex!] = comment; // Si estamos editando, actualizar el comentario
        editingIndex = null; // Limpiar el índice de edición
      }
      commentController.clear(); // Limpiar el campo de texto
    });
  }

  // Método para eliminar un comentario
  void deleteComment(int index) {
    setState(() {
      comments.removeAt(index); // Eliminar el comentario en el índice especificado
    });
  }

  // Método para iniciar la edición de un comentario
  void editComment(int index) {
    setState(() {
      commentController.text = comments[index]; // Cargar el comentario en el campo de texto
      editingIndex = index; // Establecer el índice del comentario que estamos editando
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon["name"]),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Mostrar la imagen y el corazón juntos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/${widget.pokemon["num"]}.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite; // Cambiar el estado del corazón
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.pokemon["name"],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Número: ${widget.pokemon["num"]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Altura: ${widget.pokemon["height"]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Peso: ${widget.pokemon["weight"]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Caramelos: ${widget.pokemon["candy"]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                widget.pokemon.containsKey("candy_count")
                    ? Text(
                        "Cantidad de Caramelos: ${widget.pokemon["candy_count"]}",
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox(),
                const SizedBox(height: 8),
                Text(
                  "Huevo: ${widget.pokemon["egg"]}",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Debilidades:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    widget.pokemon["weaknesses"].length,
                    (index) => Chip(
                      label: Text(
                        widget.pokemon["weaknesses"][index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sección de comentarios
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'Escribe tu comentario',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => addOrUpdateComment(commentController.text),
                  child: Text(editingIndex == null ? 'Enviar comentario' : 'Actualizar comentario'),
                ),
                const SizedBox(height: 16),
                Text(
                  "Comentarios:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Column(
                  children: comments.map((comment) {
                    int index = comments.indexOf(comment);
                    return ListTile(
                      title: Text(comment),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editComment(index), // Editar el comentario
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteComment(index), // Eliminar el comentario
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
