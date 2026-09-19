import 'package:flutter/material.dart';
import 'tarefa_model.dart';
import 'db_helper.dart';

class FormularioScreen extends StatefulWidget {
  final Tarefa? tarefa;

  const FormularioScreen({super.key, this.tarefa});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _tituloController = TextEditingController();
  final dbHelper = DatabaseHelper();
  bool _isConcluida = false; // Novo estado para controlar se está concluída

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _tituloController.text = widget.tarefa!.titulo;
      _isConcluida = widget.tarefa!.concluida; // Carrega o estado atual
    }
  }

  void _salvarTarefa() async {
    if (_tituloController.text.isEmpty) return;

    if (widget.tarefa == null) {
      // Inserir nova tarefa
      final novaTarefa = Tarefa(
        titulo: _tituloController.text,
        data: DateTime.now().toString().substring(0, 19),
        concluida: false,
      );
      await dbHelper.inserirTarefa(novaTarefa);
    } else {
      // Atualizar tarefa existente (neste caso, apenas o status de concluída)
      final tarefaAtualizada = Tarefa(
        id: widget.tarefa!.id,
        titulo: widget.tarefa!.titulo,
        data: widget.tarefa!.data, // Mantém a data original
        concluida: _isConcluida,
      );
      await dbHelper.atualizarTarefa(tarefaAtualizada);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: const Text("Tem a certeza que deseja excluir este item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              await dbHelper.deletarTarefa(widget.tarefa!.id!);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdicao = widget.tarefa != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Detalhes da Tarefa' : 'Nova Tarefa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título da Tarefa',
                border: OutlineInputBorder(),
              ),
              enabled: !isEdicao,
            ),
            const SizedBox(height: 20),
            if (!isEdicao)
              ElevatedButton(
                onPressed: _salvarTarefa,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Salvar', style: TextStyle(fontSize: 16)),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Data de Registo: ${widget.tarefa!.data}",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Novo: CheckboxListTile para marcar como concluída (LISTA CRIADA)
                  CheckboxListTile(
                    title: const Text("TAREFA CRIADA (Marcar como concluída)"),
                    value: _isConcluida,
                    onChanged: (bool? value) {
                      setState(() {
                        _isConcluida = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading, // Checkbox à esquerda
                  ),
                  const SizedBox(height: 20),

                  // Botão para salvar a alteração do estado "concluída"
                  ElevatedButton(
                    onPressed: _salvarTarefa,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Salvar Alterações', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _confirmarExclusao,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Excluir Tarefa', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}