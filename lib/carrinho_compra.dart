import 'package:flutter/material.dart';
import 'package:flutter_sqlite/listagem_produtos.dart';
import 'package:flutter_sqlite/login.dart';
import 'package:flutter_sqlite/model/produto.dart';

class CarrinhoCompra extends StatefulWidget {
  final List<int> prodSelecionados;
  final List<Produto> produtos;

  const CarrinhoCompra(
      {Key? key, required this.produtos, required this.prodSelecionados})
      : super(key: key);

  @override
  CarrinhoCompraState createState() => CarrinhoCompraState();
}

class CarrinhoCompraState extends State<CarrinhoCompra> {
  final List<Produto> _produtos = [];
  List<int> quantidadesList = [];
  bool desconto = false;
  Color textColor = Colors.black;
  Color textColorWarning = Colors.grey;
  Color borderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    setState(() {
      _produtos.addAll(widget.produtos);
      quantidadesList = List<int>.filled(widget.produtos.length, 1);
    });
  }

  int calcularQuantidadeTotal() {
    int quantidadeTotal = 0;
    for (int quantidade in quantidadesList) {
      quantidadeTotal += quantidade;
    }
    if (quantidadeTotal >= 10) {
      setState(() {
        desconto = true;
      });
    }
    return quantidadeTotal;
  }

// qtd  [1, 2, 3] 0, 1 ,2
// prod [1, 2, 3] 0, 1, 2
  List<double> calcularValorTotal() {
    int valorTotal = 0;
    for (int i = 0; i < _produtos.length; i++) {
      valorTotal += _produtos[i].preco * quantidadesList[i];
    }
    if (desconto) {
      double valorComDesconto =
          valorTotal.toDouble() - (valorTotal.toDouble() * 0.05);
      double valorDoDesconto = valorTotal.toDouble() * 0.05;
      return [valorComDesconto, valorDoDesconto];
    }
    return [valorTotal.toDouble(), 0.0];
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Pedido Enviado Com Sucesso'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ListagemProdutos(selecionados: widget.prodSelecionados),
              ),
            );
          },
        ),
        title: const Text("Carrinho"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Text(
              'Total de Produtos: ${calcularQuantidadeTotal()}',
              style: const TextStyle(
                  fontSize: 25.0, color: Color.fromARGB(255, 0, 102, 204)),
            ),
            Text(
              'Valor Total: ${calcularValorTotal()[0]}',
              style: const TextStyle(
                  fontSize: 25.0, color: Color.fromARGB(255, 0, 102, 204)),
            ),
            Text(
              desconto ? 'Desconto: 5%' : 'Desconto: 0%',
              style: TextStyle(
                  fontSize: 18.0,
                  color: desconto ? Colors.green : Colors.black),
            ),
            desconto
                ? Text(
                    "Valor do Desconto: ${calcularValorTotal()[1]}",
                    style: TextStyle(fontSize: 18.0, color: Colors.green),
                  )
                : Container(),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _produtos[index];
                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Produto ${item.id}',
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${item.nome}',
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Preço: ${item.preco}',
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Quantidade'),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        quantidadesList[index] =
                                            int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    primary: const Color.fromARGB(255, 255, 162, 156),
                  ),
                  child: const Text('Cancelar Pedido'),
                ),
                ElevatedButton(
                  onPressed: _showSuccessDialog,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 50),
                    primary: Color.fromARGB(255, 136, 193, 249),
                  ),
                  child: const Text('Comprar'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
