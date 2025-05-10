import 'dart:convert';

class Dependente {
  final String _nome;

  Dependente(this._nome);

  String get nome => _nome;

  Map<String, dynamic> toJson() => {
        'nome': _nome,
      };
}

class Funcionario {
  final String _nome;
  final List<Dependente> _dependentes;

  Funcionario(this._nome, this._dependentes);

  String get nome => _nome;
  List<Dependente> get dependentes => _dependentes;

  Map<String, dynamic> toJson() => {
        'nome': _nome,
        'dependentes': _dependentes.map((d) => d.toJson()).toList(),
      };
}

class EquipeProjeto {
  final String _nomeProjeto;
  final List<Funcionario> _funcionarios;

  EquipeProjeto(this._nomeProjeto, this._funcionarios);

  Map<String, dynamic> toJson() => {
        'nomeProjeto': _nomeProjeto,
        'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
      };
}

void main() {
  // 1. Criar vários objetos Dependentes
  final dep1 = Dependente('Patricia');
  final dep2 = Dependente('Sergio');
  final dep3 = Dependente('Anderson');
  final dep4 = Dependente('Pamela');
  final dep5 = Dependente('Eduardo');

  // 2. Criar vários objetos Funcionario
  final func1 = Funcionario('Fco Klayrton', [dep1, dep2]);
  final func2 = Funcionario('Lucas Guedes', [dep3, dep4,dep5]);

  // 4. Criar uma lista de Funcionarios
  final funcionarios = [func1, func2];

  // 5. Criar um objeto Equipe Projeto
  final equipe = EquipeProjeto('Sistema de Vendas', funcionarios);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  print(jsonEncode(equipe.toJson()));
}