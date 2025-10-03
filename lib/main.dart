// Lucas Gabriel e Paulo Vitor - 2º INF
import 'package:flutter/material.dart';

void main() {
  runApp(BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  const BibliotecaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Biblioteca",
      theme:  ThemeData(),
      home: BibliotecaHome(),
    );
  }
}

class BibliotecaHome extends StatefulWidget {
  const BibliotecaHome({super.key});

  @override
  State<BibliotecaHome> createState() => BibliotecaState();
}

class BibliotecaState extends State<BibliotecaHome> {
  String? generoSelecionado;
  String busca = "";

  final Map<String, List<String>> generos = {
    "Ficção": [],
    "Não Ficção": [],
    "Aventura": [],
    "Fantasia": []
  };

  List<String> get generosAtuais => 
    generos[generoSelecionado] ?? const <String>[];

  Future<void> editarGenero(BuildContext context, int indexReal) async { 
    if (indexReal < 0 || indexReal >= generosAtuais.length) return; 
 
    final racaAtual = generosAtuais[indexReal]; 
    final controller = TextEditingController(text: racaAtual); 
 
    final novaRaca = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Editar raça'), 
        content: TextField( 
          controller: controller, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome da raça', 
            border: OutlineInputBorder(), 
          ), 
          textInputAction: TextInputAction.done, 
          onSubmitted: (_) => Navigator.of(ctx).pop(controller.text.trim()), 
        ), 
        actions: [ 
          TextButton( 
            onPressed: () => Navigator.of(ctx).pop(null), 
            child: const Text('Cancelar'), 
          ), 
          FilledButton( 
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()), 
            child: const Text('Salvar'), 
          ), 
        ], 
      ), 
    ); 
 
    if (novaRaca == null) return; 
    if (novaRaca.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = generosAtuais.any( 
      (r) => r.toLowerCase() == novaRaca.toLowerCase(), 
    ); 
    if (jaExiste && novaRaca.toLowerCase() != racaAtual.toLowerCase()) { 
      exibirMensagem('Já existe uma raça com esse nome.'); 
      return; 
    } 
 
    setState(() { 
      generosAtuais[indexReal] = _capitalizar(novaRaca); 
    }); 
    exibirMensagem('Raça atualizada para "${generosAtuais[indexReal]}".'); 
  } 

  Future<void> adicionarLivro(BuildContext context) async { 
    final textController = TextEditingController();  
 
    final novaRaca = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Adicionar raça'), 
        content: TextField( 
          controller: textController, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome da raça', 
            border: OutlineInputBorder(), 
          ), 
          onSubmitted: (_) => Navigator.of(ctx).pop(textController.text.trim()), 
        ), 
        actions: [ 
          TextButton( 
            onPressed: () => Navigator.of(ctx).pop(null), 
            child: const Text('Cancelar'), 
          ), 
          FilledButton( 
            onPressed: () => Navigator.of(ctx).pop(textController.text.trim()), 
            child: const Text('Adicionar'), 
          ), 
        ], 
      ), 
    ); 
 
    if (novaRaca == null) return; 
    if (novaRaca.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = generosAtuais.any( 
      (r) => r.toLowerCase() == novaRaca.toLowerCase(), 
    ); 
    if (jaExiste) { 
      exibirMensagem('Já existe uma raça com esse nome.'); 
      return; 
    } 
 
    setState(() { 
      generosAtuais.add(_capitalizar(novaRaca));
    }); 
    exibirMensagem('Raça "${_capitalizar(novaRaca)}" adicionada.'); 
  } 

  Future<void> adicionarGenero(BuildContext context) async { 
    final textController = TextEditingController();  
 
    final novaRaca = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Adicionar raça'), 
        content: TextField( 
          controller: textController, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome da raça', 
            border: OutlineInputBorder(), 
          ), 
          onSubmitted: (_) => Navigator.of(ctx).pop(textController.text.trim()), 
        ), 
        actions: [ 
          TextButton( 
            onPressed: () => Navigator.of(ctx).pop(null), 
            child: const Text('Cancelar'), 
          ), 
          FilledButton( 
            onPressed: () => Navigator.of(ctx).pop(textController.text.trim()), 
            child: const Text('Adicionar'), 
          ), 
        ], 
      ), 
    ); 
 
    if (novaRaca == null) return; 
    if (novaRaca.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = generosAtuais.any( 
      (r) => r.toLowerCase() == novaRaca.toLowerCase(), 
    ); 
    if (jaExiste) { 
      exibirMensagem('Já existe uma raça com esse nome.'); 
      return; 
    } 
 
    setState(() { 
      generosAtuais.add(_capitalizar(novaRaca));
    }); 
    exibirMensagem('Raça "${_capitalizar(novaRaca)}" adicionada.'); 
  } 

  List<String> get generosFiltrados =>
    busca.isEmpty
      ? generosAtuais
      : generosAtuais.where((r) => r.toLowerCase().contains(busca.toLowerCase())).toList();

  void exibirMensagem(String msg) { 
    ScaffoldMessenger.of(context) 
      ..hideCurrentSnackBar() 
      ..showSnackBar(SnackBar(content: Text(msg))); 
  } 
  
  String _capitalizar(String s) { 
    if (s.isEmpty) return s; 
    return s[0].toUpperCase() + s.substring(1); 
  } 

  DropdownButtonFormField<String> mainDropdown(Map<String, List<String>> itens) {
    return DropdownButtonFormField<String>(
      hint: Text("Selecione o gênero"),
      initialValue: generoSelecionado,
      icon: Icon(Icons.arrow_drop_down),
      items: itens.keys.map((genero) {
        return DropdownMenuItem<String>(
          value: genero,
          child: Row(
            children: [
              Icon(Icons.add),
              Text(genero)
            ],
          )
        );
      }).toList(), 
      onChanged: (String? selecao) {
        setState(() {
          generoSelecionado = selecao;
          busca = "";
        });
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biblioteca Flutter - Lucas e Paulo"),
      ),
      body: Padding(padding: EdgeInsets.all(18), 
        child: Column(
          children: [
            mainDropdown(generos),
            SizedBox(height: 12), 
            TextField( 
              decoration: const InputDecoration( 
                border: OutlineInputBorder(), 
                prefixIcon: Icon(Icons.search), 
                hintText: 'Buscar livro...', 
              ), 
              onChanged: (txt) {
                setState(() {
                  busca = txt;
                });
              }, 
            ), 
            SizedBox(height: 20), 
            Expanded( 
              child: generosFiltrados.isEmpty 
                ? const Center(child: Text('Nenhum resultado.')) 
                : ListView.separated( 
                    itemCount: generosFiltrados.length, 
                    separatorBuilder: (_, __) => const Divider(height: 1), 
                    itemBuilder: (context, indexFiltrado) { 
                      final livro = generosFiltrados[indexFiltrado]; 
                      return ListTile( 
                        leading: const Icon(Icons.book), 
                        title: Text(livro), 
                        trailing: Row( 
                          mainAxisSize: MainAxisSize.min, 
                          children: [ 
                            IconButton( 
                              tooltip: 'Editar', 
                              icon: const Icon(Icons.edit, color: Colors.blue), 
                              onPressed: () {}, 
                            ), 
                            IconButton( 
                            tooltip: 'Excluir', 
                              icon: const Icon(Icons.delete, color: Colors.red), 
                              onPressed: () {}, 
                            ), 
                          ], 
                        ), 
                        onTap: () => exibirMensagem('Você selecionou: $livro'), 
                      ); 
                    }, 
                  ), 
            ), 
          ],
        ),
      )
    );
  }
}