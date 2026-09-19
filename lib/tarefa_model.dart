class Tarefa {
  int? id;
  String titulo;
  String data;
  bool concluida; // Novo campo

  Tarefa({
    this.id,
    required this.titulo,
    required this.data,
    this.concluida = false, // Por padrão, uma tarefa nova não está concluída
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'data': data,
      'concluida': concluida ? 1 : 0, // Converte boolean para inteiro (SQLite)
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      data: map['data'],
      concluida: map['concluida'] == 1, // Converte inteiro para boolean
    );
  }
}