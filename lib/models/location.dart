class Estado {
  final int id;
  final String nome;
  final String sigla;

  Estado({
    required this.id,
    required this.nome,
    required this.sigla,
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json['id'] as int,
      nome: json['nome'] as String,
      sigla: json['sigla'] as String,
    );
  }
}

class City {
  final int id;
  final String nome;
  final int stateId;

  City({
    required this.id,
    required this.nome,
    required this.stateId,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      nome: json['nome'] as String,
      stateId: json['microrregiao']['mesorregiao']['UF']['id'] as int,
    );
  }
}
