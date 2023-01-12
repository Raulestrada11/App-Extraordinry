import 'package:aplicaion_ordinario/dbconfiguracion/dbservicios.dart';
import 'package:aplicaion_ordinario/pantallas/login.dart';
import 'package:aplicaion_ordinario/pantallas/pantalla_editar.dart';
import 'package:aplicaion_ordinario/pantallas/registro_libros.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PantallaUsuarios extends StatefulWidget {
  static String id = "usuariospage";
  const PantallaUsuarios({Key key}) : super(key: key);

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 5, 112),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 14,
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 30),
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 7, spreadRadius: 3, color: Colors.purple)
                    ],
                    shape: BoxShape.circle,
                    color:
                        const Color.fromARGB(255, 96, 5, 112).withOpacity(0.5)),
                child: IconButton(
                  onPressed: (() async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, Login.id);
                  }),
                  icon: const Icon(
                    Icons.logout,
                    size: 20,
                  ),
                  alignment: Alignment.center,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.book),
          onPressed: () {},
        ),
        title: const Text('Lista de Libros'),
      ),
      body: StreamBuilder<User>(
        stream: firebaseAuth.authStateChanges(),
        builder: (((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: FutureBuilder(
                future: getlibros(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData) {
                            return Card(
                              elevation: 10,
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                minLeadingWidth: 50,
                                leading: Image.network(
                                  snapshot.data[index]['photo'],
                                  width: 70,
                                ),
                                title: Text(snapshot.data[index]['name']),
                                subtitle: Text(
                                    'Autor: ${snapshot.data[index]['author']}\nAño de Lanzamiento: ${snapshot.data[index]['year']}'),
                                trailing: PopupMenuButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.delete,
                                                  color: Color.fromARGB(
                                                      255, 96, 5, 112)),
                                              title: Text('Eliminar'),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: const Icon(Icons.edit,
                                                  color: Color.fromARGB(
                                                      255, 96, 5, 112)),
                                              title: const Text('Editar'),
                                              onTap: () async {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PantallaEditar(
                                                                userID: snapshot
                                                                            .data[
                                                                        index]
                                                                    ["id"])));
                                                setState(() {});
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                              },
                                            ),
                                          )
                                        ]),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        });
                  }
                }),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: (() async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistroUsuarios()));
                  setState(() {});
                }),
                backgroundColor: const Color.fromARGB(255, 96, 5, 112),
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return const Center(
              // child: CircularProgressIndicator(),
              child: Text("No hay estudiantes registrados"),
            );
          }
        })),
      ),
    ));
  }
}
