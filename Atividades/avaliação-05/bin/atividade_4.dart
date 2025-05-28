import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Open (or create) the database file
  final db = sqlite3.open('alunos.db');

  // Create table TB_ALUNO if it doesn't exist
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(50) NOT NULL
    );
  ''');

  void inserirAluno() {
    stdout.write('Digite o nome do aluno: ');
    final nome = stdin.readLineSync();

    if (nome == null || nome.isEmpty) {
      print('Nome inválido. Tente novamente.');
      return;
    }

    if (nome.length > 50) {
      print('Nome muito longo. O máximo permitido é 50 caracteres.');
      return;
    }

    final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
    stmt.execute([nome]);
    stmt.dispose();

    print('Aluno "$nome" inserido com sucesso.');
  }

  void listarAlunos() {
    final result = db.select('SELECT id, nome FROM TB_ALUNO');

    if (result.isEmpty) {
      print('Nenhum aluno cadastrado.');
      return;
    }

    print('\nLista de Alunos:');
    for (final row in result) {
      print('ID: ${row['id']} - Nome: ${row['nome']}');
    }
    print('');
  }

  while (true) {
    print('Escolha a opção:');
    print('1 - Inserir aluno');
    print('2 - Listar alunos');
    print('0 - Sair');
    stdout.write('> ');

    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        inserirAluno();
        break;
      case '2':
        listarAlunos();
        break;
      case '0':
        print('Encerrando o programa...');
        db.dispose();
        exit(0);
      default:
        print('Opção inválida. Tente novamente.');
    }
  }
}
