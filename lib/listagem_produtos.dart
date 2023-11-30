import 'package:flutter_sqlite/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/login.dart';
import 'package:flutter_sqlite/model/produto.dart';
import 'carrinho_compra.dart';

class ListagemProdutos extends StatefulWidget {
  final List<int> selecionados;
  const ListagemProdutos({
    Key? key,
    this.selecionados = const [],
  }) : super(key: key);

  @override
  ListagemProdutosState createState() => ListagemProdutosState();
}

class ListagemProdutosState extends State<ListagemProdutos> {
  late DB _database = DB.instance;
  List<int> selecionadosIndices = [];
  final List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _loadDBinstance();
    loadProducts();
    loadProdutosSelecinados();
  }

  void loadProdutosSelecinados() {
    if (!widget.selecionados.isEmpty) {
      for (int index in widget.selecionados) {
        setState(() {
          selecionadosIndices.add(index);
        });
      }
    }
  }

  _loadDBinstance() async {
    try {
      _database = DB.instance;
    } catch (error) {
      print("Error on loading database instance: $error");
    }
  }

  loadProducts() async {
    try {
      List<Produto> listProduto = await _database.getProdutcts();
      setState(() {
        _produtos.addAll(listProduto);
      });
    } catch (error) {
      print("Error on loading products: $error");
    }
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
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
        ),
        title: const Text("Login"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Text(
            'Selecionar Produto',
            style: TextStyle(
                fontSize: 25.0, color: const Color.fromARGB(255, 3, 46, 81)),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 100, 99, 99), width: 1.0),
              ),
              child: ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (BuildContext context, int index) {
                  final Produto produto = _produtos[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selecionadosIndices.contains(index)) {
                          selecionadosIndices.remove(index);
                        } else {
                          selecionadosIndices.add(index);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selecionadosIndices.contains(index)
                              ? const Color.fromARGB(255, 141, 199, 247)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cod #${produto.id}',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Nome: ${produto.nome}',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Descrição: ${produto.descricao}',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Preço: ${produto.preco.toStringAsFixed(2)} Reais',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                'Quantidade: ${produto.quantidade}',
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              List<Produto> produtosSelecionados = [];

              if (selecionadosIndices.isNotEmpty) {
                for (int index in selecionadosIndices) {
                  produtosSelecionados.add(_produtos[index]);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarrinhoCompra(
                    prodSelecionados: selecionadosIndices,
                    produtos: produtosSelecionados,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
              ),
              child: const Text('Avançar'),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
