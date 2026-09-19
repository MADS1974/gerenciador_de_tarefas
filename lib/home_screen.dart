import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'tarefa_model.dart';
import 'formulario_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<Tarefa> tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final lista = await dbHelper.obterTarefas();
    setState(() {
      tarefas = lista;
    });
  }

  void _navegarParaFormulario([Tarefa? tarefa]) async {
    // Fica à espera que o formulário seja fechado
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormularioScreen(tarefa: tarefa)),
    );

    // Se o resultado for 'true' (inseriu ou apagou), recarrega a lista do SQLite
    if (resultado == true) {
      _carregarTarefas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BD com Lista'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: tarefas.isEmpty
          ? const Center(child: Text('Nenhum item registado.'))
          : ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                    '${tarefa.id}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ),
              title: Text(
                  tarefa.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // (Opcional) Rasurar o texto se estiver concluída
                    decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
                  )
              ),
              subtitle: Text(tarefa.data),

              // Novo: Adicionar o ícone de check se estiver concluída
              trailing: tarefa.concluida
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,

              onTap: () => _navegarParaFormulario(tarefa),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaFormulario(),
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }
}