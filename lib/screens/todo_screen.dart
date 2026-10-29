import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tareas = ['Tarea 1', 'Tarea 2', 'Tarea 3'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _agregar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      _tareas.add(texto);
      _controller.clear();
    });
  }

  void _borrar(int index) {
    setState(() {
      _tareas.removeAt(index);
    });
  }

  Future<void> _editar(int index) async {
    final editController = TextEditingController(text: _tareas[index]);

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

    if (nuevoTexto != null && nuevoTexto.trim().isNotEmpty) {
      setState(() {
        _tareas[index] = nuevoTexto.trim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
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
                return Slidable(
                  key: ValueKey('${_tareas[index]}-$index'),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _editar(index),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (_) => _borrar(index),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Borrar',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Text(_tareas[index]),
                    trailing: const Icon(Icons.chevron_left),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
