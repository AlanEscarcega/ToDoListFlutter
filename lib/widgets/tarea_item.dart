import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist_app/models/tarea.dart';

class TareaItem extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onEditar;
  final VoidCallback onBorrar;
  final VoidCallback onCambiar;

  const TareaItem({
    super.key,
    required this.tarea,
    required this.onEditar,
    required this.onBorrar,
    required this.onCambiar,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ObjectKey(tarea),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEditar(),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (_) => onBorrar(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Borrar',
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: tarea.completada,
          onChanged: (_) => onCambiar(),
        ),
        title: Text(
          tarea.titulo,
          style: TextStyle(
            decoration: tarea.completada ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: const Icon(Icons.drag_handle),
      ),
    );
  }
}
