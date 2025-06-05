import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Cliente {
  int codigo;
  String nome;
  int tipoCliente;

  Cliente({required this.codigo, required this.nome, required this.tipoCliente});

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'nome': nome,
    'tipoCliente': tipoCliente,
  };
}

class Vendedor {
  int codigo;
  String nome;
  double comissao;

  Vendedor({required this.codigo, required this.nome, required this.comissao});

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'nome': nome,
    'comissao': comissao,
  };
}

class Veiculo {
  int codigo;
  String descricao;
  double valor;

  Veiculo({required this.codigo, required this.descricao, required this.valor});

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'descricao': descricao,
    'valor': valor,
  };
}

class ItemPedido {
  int sequencial;
  String descricao;
  int quantidade;
  double valor;

  ItemPedido({required this.sequencial, required this.descricao, required this.quantidade, required this.valor});

  Map<String, dynamic> toJson() => {
    'sequencial': sequencial,
    'descricao': descricao,
    'quantidade': quantidade,
    'valor': valor,
  };
}

class PedidoVenda {
  String codigo;
  DateTime data;
  double valorPedido;
  Cliente cliente;
  Vendedor vendedor;
  Veiculo veiculo;
  List<ItemPedido> items;

  PedidoVenda({
    required this.codigo,
    required this.data,
    required this.valorPedido,
    required this.cliente,
    required this.vendedor,
    required this.veiculo,
    required this.items,
  });

  double calcularPedido() {
    valorPedido = items.fold(0.0, (total, item) => total + (item.valor * item.quantidade));
    return valorPedido;
  }

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'data': data.toIso8601String(),
    'valorPedido': calcularPedido(),
    'cliente': cliente.toJson(),
    'vendedor': vendedor.toJson(),
    'veiculo': veiculo.toJson(),
    'items': items.map((item) => item.toJson()).toList(),
  };
}

void main() async {
  // Novos dados de exemplo
  var cliente = Cliente(codigo: 202, nome: 'Carlos Mendes', tipoCliente: 1);
  var vendedor = Vendedor(codigo: 303, nome: 'Luciana Prado', comissao: 7.25);
  var veiculo = Veiculo(codigo: 505, descricao: 'SUV Turbo 2.0', valor: 78000.00);
  var itens = [
    ItemPedido(sequencial: 1, descricao: 'Teto Solar Panorâmico', quantidade: 1, valor: 4800.0),
    ItemPedido(sequencial: 2, descricao: 'Central Multimídia', quantidade: 1, valor: 3200.0),
    ItemPedido(sequencial: 3, descricao: 'Câmera de Ré', quantidade: 1, valor: 1100.0),
  ];

  var pedido = PedidoVenda(
    codigo: 'PDV987',
    data: DateTime.now(),
    valorPedido: 0.0,
    cliente: cliente,
    vendedor: vendedor,
    veiculo: veiculo,
    items: itens,
  );

  var encoder = JsonEncoder.withIndent('  ');
  var jsonFormatado = encoder.convert(pedido.toJson());

  final arquivoJson = File('pedido_venda.json');
  await arquivoJson.writeAsString(jsonFormatado);
  print('\n📁 Arquivo JSON salvo como "pedido_venda.json".');

  stdout.write('Digite o e-mail do destinatário: ');
  String? destinatario = stdin.readLineSync();

  stdout.write('Digite o assunto: ');
  String? assunto = stdin.readLineSync();

  stdout.write('Digite a mensagem: ');
  String? corpoMensagem = stdin.readLineSync();

  final smtpServer = gmail('seu_email', 'sua_senha_app');
// o meu institucional n gerou a senha pp
  final message = Message()
    ..from = Address('seu_email, 'seu_nome')
    ..recipients.add(destinatario ?? '')
    ..subject = assunto ?? 'Pedido de Venda JSON'
    ..text = corpoMensagem ?? ''
    ..attachments = [FileAttachment(arquivoJson)];

  try {
    final sendReport = await send(message, smtpServer);
    print('\n✅ E-mail enviado com sucesso!');
    print('📬 Destinatário: $destinatario');
    print('📝 Assunto: $assunto');
  } catch (e) {
    print('\n❌ Erro ao enviar o e-mail: $e');
  }
}
