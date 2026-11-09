import 'package:flutter/material.dart';
import 'package:todolist_app/models/tarea.dart';
import 'package:todolist_app/widgets/tarea_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Tarea> _tareas = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _existe(String texto, {Tarea? excepto}) {
    return _tareas.any(
      (t) => t != excepto && t.titulo.toLowerCase() == texto.toLowerCase(),
    );
  }

  void _avisoRepetida() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Esa tarea ya existe')));
  }

  void _agregar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    if (_existe(texto)) {
      _avisoRepetida();
      return;
    }
    setState(() {
      _tareas.add(Tarea(titulo: texto));
      _controller.clear();
    });
  }

  void _borrar(Tarea tarea) {
    setState(() {
      _tareas.remove(tarea);
    });
  }

  void _cambiarEstado(Tarea tarea) {
    setState(() {
      tarea.completada = !tarea.completada;
    });
  }

  Future<void> _editar(Tarea tarea) async {
    final editController = TextEditingController(text: tarea.titulo);

    final nuevoTexto = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(controller: editController, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, editController.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    editController.dispose();

    if (!mounted) return;

    if (nuevoTexto != null && nuevoTexto.trim().isNotEmpty) {
      if (_existe(nuevoTexto.trim(), excepto: tarea)) {
        _avisoRepetida();
        return;
      }
      setState(() {
        tarea.titulo = nuevoTexto.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _agregar(),
                    decoration: const InputDecoration(
                      hintText: 'Escribe una tarea...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _agregar,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return TareaItem(
                  tarea: tarea,
                  onEditar: () => _editar(tarea),
                  onBorrar: () => _borrar(tarea),
                  onCambiar: () => _cambiarEstado(tarea),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
