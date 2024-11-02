import 'package:flutter/material.dart';

class pagina2 extends StatelessWidget {
  const pagina2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text("Bienvenidos a la página 2"),
        ElevatedButton(
            onPressed: () => {
                  Navigator.pop(context),
                },
            child: Text("Volver al inicio"))
      ],
    ));
  }
}
