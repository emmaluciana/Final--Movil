// import 'package:finalmovil1/pages/pagina2.dart';
// // import 'package:finalmovil1/pages/pagina3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Appli());
}

class Appli extends StatelessWidget {
  const Appli({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Appli nueva',
      home: Inicio(title: 'Creando en flutter'),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key, required this.title});
  final String title;

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  // @override
  // void initState() {
  //   super.initState();
  //   getUsuarios();
  // }

  // void getUsuarios() async {
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection("usuarios");

  //   QuerySnapshot usuarios = await collectionReference.get();

  //   if (usuarios.docs.isNotEmpty) {
  //     for (var doc in usuarios.docs) {
  //       print(doc.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Cuerpo(context: context),
    );
  }
}

class Cuerpo extends StatelessWidget {
  final BuildContext context;

  const Cuerpo({super.key, required this.context});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset_image/fondo.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          nombre(context),
          campoUsuario(),
          compoContrasena(),
          const SizedBox(
            height: 10,
          ),
          botonEntrar(context),
        ],
      )),
    );
  }
}

Widget nombre(BuildContext context) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 232, 126, 250),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal)),
    child: const Text(
      "Iniciar Sesión",
    ),
  );
}

Widget campoUsuario() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
    child: const TextField(
      decoration: InputDecoration(
          hintText: "Usuario", fillColor: Colors.white, filled: true),
    ),
  );
}

Widget compoContrasena() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
    child: const TextField(
      obscureText: true,
      decoration: InputDecoration(
          hintText: "Contraseña", fillColor: Colors.white, filled: true),
    ),
  );
}

Widget botonEntrar(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotasPage()));
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 232, 126, 250),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal)),
    child: const Text(
      "Entrar",
    ),
  );
}

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final List<String> _notas = [];
  final TextEditingController _notaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notasFirestore();
  }

  void _notasFirestore() async {
    CollectionReference notasCollection =
        FirebaseFirestore.instance.collection('notas');
    QuerySnapshot notasSnapshot = await notasCollection.get();

    if (notasSnapshot.docs.isNotEmpty) {
      setState(() {
        _notas.addAll(
            notasSnapshot.docs.map((doc) => doc['text'] as String).toList());
      });
    }
  }

  void _addNota() async {
    if (_notaController.text.isNotEmpty) {
      setState(() {
        _notas.add(_notaController.text);
      });

      CollectionReference notasCollection =
          FirebaseFirestore.instance.collection('notas');
      await notasCollection.add({'nota': _notaController.text});

      _notaController.clear();
    }
  }

  void _removeNotaAt(int index) async {
    String notaToRemove = _notas[index];

    setState(() {
      _notas.removeAt(index);
    });

    CollectionReference notasCollection =
        FirebaseFirestore.instance.collection('notas');
    QuerySnapshot querySnapshot =
        await notasCollection.where('text', isEqualTo: notaToRemove).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }

  // void _addNota() {
  //   if (_notaController.text.isNotEmpty) {
  //     setState(() {
  //       _notas.add(_notaController.text);
  //       _notaController.clear();
  //     });
  //   }
  // }

  // void _removeNotaAt(int index) {
  //   setState(() {
  //     _notas.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOC DE NOTAS'),
        backgroundColor: Colors.purple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _notaController,
              decoration: const InputDecoration(labelText: 'Escribir nota'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.purple[100]),
              onPressed: _addNota,
              child: const Text('Agregar'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.purple[50],
                    child: ListTile(
                      title: Text(_notas[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeNotaAt(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
