import 'package:flutter/material.dart';
import 'package:flutter_sqlite/database/db.dart';
import 'package:flutter_sqlite/listagem_produtos.dart';
import 'package:flutter_sqlite/model/usuario.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  late DB _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  _initDatabase() async {
    try {
      _database = DB.instance;
      print("Opening the database...");
      await _database.openDatabaseConnection();
      print("Database connection successful!");
    } catch (error) {
      print("Error opening the database: $error");
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      List<Usuario> usuarios =
          await _database.getUserByEmailAndPassword(email, senha);
      if (usuarios.isNotEmpty) {
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  final TextEditingController _usuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/flutter.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            const Text(
              'Usuário',
              style: TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 3, 46, 81)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: _usuario,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Usuário",
                  prefixIcon: const Icon(Icons.account_circle_outlined),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 3, 46, 81)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 3, 46, 81)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Senha',
              style: TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 3, 46, 81)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                obscureText: true,
                obscuringCharacter: "*",
                controller: _senha,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Entre com a senha",
                  prefixIcon: const Icon(Icons.lock),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 3, 46, 81)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromARGB(255, 3, 46, 81)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 170,
              child: ElevatedButton(
                onPressed: () async {
                  bool ret = await login(_usuario.text, _senha.text);
                  if (ret) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ListagemProdutos(selecionados: []),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Login inválido, email ou senha incorretos!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(220, 20),
                ),
                child: const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
