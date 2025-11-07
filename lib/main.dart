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
      theme:  ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red), 
        useMaterial3: true
      ),
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
    "Ficção": [
      "1984 - George Orwell", 
      "Admirável Mundo Novo - Aldous Huxley",  
      "Neuromancer - William Gibson"
    ],
    "Não Ficção": [
      "Sapiens - Yuval Noah Harari", 
      "A Arte da Guerra - Sun Tzu", 
      "O Gene - Siddhartha Mukherjee"
    ],
    "Aventura": [
      "Robinson Crusoé - Daniel Defoe", 
      "A Ilha do Tesouro - Robert Louis Stevenson", 
      "Viagem  ao Centro da Terra - Júlio Verne"
    ],
    "Fantasia": [
      "Senhor dos Anéis - J.R.R. Tolkien", 
      "Harry Potter - J.K. Rowling", 
      "As Crônicas do Gelo e Fogo - George R.R. Martin"
    ],
  };
  final TextEditingController clearController = TextEditingController();

  List<String> get livrosAtuais => 
    generos[generoSelecionado] ?? const <String>[];

  // Funções para manipular livros

  Future<void> editarLivro(BuildContext context, int indexReal) async { 
    if (indexReal < 0 || indexReal >= livrosAtuais.length) return; 

    final livroAtual = livrosAtuais[indexReal]; 
    final controller = TextEditingController(text: livroAtual); 
 
    final novoLivro = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Editar livro'), 
        content: TextField( 
          controller: controller, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome do livro', 
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
 
    if (novoLivro == null) return; 
    if (novoLivro.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = livrosAtuais.any( 
      (r) => r.toLowerCase() == novoLivro.toLowerCase(), 
    ); 
    if (jaExiste && novoLivro.toLowerCase() != livroAtual.toLowerCase()) { 
      exibirMensagem('Já existe um livro com esse nome.'); 
      return; 
    } 
 
    setState(() { 
      livrosAtuais[indexReal] = _capitalizar(novoLivro); 
    }); 
    exibirMensagem('Livro atualizado para "${livrosAtuais[indexReal]}".'); 
  } 

  Future<void> adicionarLivro(BuildContext context) async { 
    final textController = TextEditingController();  
 
    final novoLivro = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Adicionar livro'), 
        content: TextField( 
          controller: textController, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome do livro', 
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
 
    if (novoLivro == null) return; 
    if (novoLivro.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = livrosAtuais.any( 
      (r) => r.toLowerCase() == novoLivro.toLowerCase(), 
    ); 
    if (jaExiste) { 
      exibirMensagem('Já existe um livro com esse nome.'); 
      return; 
    } 
 
    setState(() { 
      livrosAtuais.add(_capitalizar(novoLivro));
    }); 
    exibirMensagem('Livro "${_capitalizar(novoLivro)}" adicionado.'); 
  } 

  Future<void> excluirLivro(BuildContext context, int indexReal) async { 
    if (indexReal < 0 || indexReal >= livrosAtuais.length) return; 
    final livro = livrosAtuais[indexReal]; 
 
    final confirmar = await showDialog<bool>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Excluir livro'), 
        content: Text('Tem certeza que deseja excluir "$livro"?'), 
        actions: [ 
          TextButton( 
            onPressed: () => Navigator.of(ctx).pop(false), 
            child: const Text('Cancelar'), 
          ), 
          FilledButton( 
            onPressed: () => Navigator.of(ctx).pop(true), 
            child: const Text('Excluir'), 
          ), 
        ], 
      ), 
    ); 
 
    if (confirmar != true) return; 
 
    setState(() { 
      livrosAtuais.removeAt(indexReal); 
    }); 
    exibirMensagem('Livro "$livro" excluído.'); 
  }

  // Fim das funções para manipular livros
  // --------------------------------------

  // Funções para manipular gêneros 

  Future<void> editarGenero(BuildContext context, String genero) async {
    if (!generos.containsKey(genero)) return; 
 
    final generoAtual = genero; 
    final controller = TextEditingController(text: generoAtual); 
 
    final novoGenero = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Editar Gênero'), 
        content: TextField( 
          controller: controller, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome do Gênero', 
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
 
    if (novoGenero == null) return; 
    if (novoGenero.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = generos.containsKey(novoGenero);

    if (jaExiste && novoGenero.toLowerCase() != generoAtual.toLowerCase()) { 
      exibirMensagem('Já existe esse gênero.'); 
      return; 
    } 
 
    setState(() { 
      List<String> livros = livrosAtuais; 
      generos.remove(generoAtual);
      generoSelecionado = _capitalizar(novoGenero);
      generos[_capitalizar(novoGenero)] = livros;
    }); 
    exibirMensagem('Gênero $generoAtual atualizado para "${_capitalizar(novoGenero)}"'); 
  }

  Future<void> adicionarGenero(BuildContext context) async { 
     final textController = TextEditingController();  
 
    final novoGenero = await showDialog<String?>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Adicionar gênero'), 
        content: TextField( 
          controller: textController, 
          autofocus: true, 
          decoration: const InputDecoration( 
            labelText: 'Nome do gênero', 
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
 
    if (novoGenero == null) return; 
    if (novoGenero.isEmpty) { 
      exibirMensagem('O nome não pode ser vazio.'); 
      return; 
    } 
 
    final jaExiste = generos.containsKey(novoGenero); 
    
    if (jaExiste) { 
      exibirMensagem('Já existe esse gênero.'); 
      return; 
    } 

    setState(() { 
      generos[ _capitalizar(novoGenero)] = [];
      generoSelecionado = _capitalizar(novoGenero);
    }); 
    exibirMensagem('Gênero "${_capitalizar(novoGenero)}" adicionado.'); 
  }

  Future<void> excluirGenero(BuildContext context, String genero) async {
    if (!generos.containsKey(genero)) return; 

    final confirmar = await showDialog<bool>( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        title: const Text('Excluir livro'), 
        content: Text('Tem certeza que deseja excluir "$genero"?'), 
        actions: [ 
          TextButton( 
            onPressed: () => Navigator.of(ctx).pop(false), 
            child: const Text('Cancelar'), 
          ), 
          FilledButton( 
            onPressed: () => Navigator.of(ctx).pop(true), 
            child: const Text('Excluir'), 
          ), 
        ], 
      ), 
    ); 
 
    if (confirmar != true) return; 
 
    setState(() { 
      generos.remove(genero);
      generoSelecionado = null;
    }); 
    exibirMensagem('Gênero "$genero" excluído.'); 
  }

  // Fim das funções para manipular gêneros
  // --------------------------------------

  List<String> get generosFiltrados =>
    busca.isEmpty
      ? livrosAtuais
      : livrosAtuais.where((r) => r.toLowerCase().contains(busca.toLowerCase())).toList();

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
      hint: Row(
        children: [
          Icon(Icons.bookmark),
          SizedBox(width: 8),
          Text("Selecione um gênero")
        ],
      ),
      initialValue: generoSelecionado,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      icon: Icon(Icons.arrow_drop_down),
      items: itens.keys.map((genero) {
        return DropdownMenuItem<String>(
          value: genero,
          child: Row(
            children: [
              Icon(Icons.bookmark),
              SizedBox(width: 8),
              Text(genero)
            ],
          )
        );
      }).toList(), 
      onChanged: (String? selecao) {
        setState(() {
          generoSelecionado = selecao;
          busca = "";
          clearController.text = "";
        });
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Biblioteca Flutter",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generoSelecionado == null 
                    ? () => exibirMensagem('Selecione um gênero antes de adicionar.') 
                    : () => adicionarLivro(context),
        tooltip: 'Adicionar Livro',
        child: Icon(Icons.add),
      ),
      body: Padding(padding: EdgeInsets.all(18), 
        child: Column(
          children: [
            mainDropdown(generos),
            SizedBox(height: 12), 
            TextField(
              controller: clearController,
              enabled: generoSelecionado != null,
              decoration: const InputDecoration( 
                border: OutlineInputBorder(), 
                prefixIcon: Icon(Icons.search), 
                hintText: "Buscar livro", 
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
                              onPressed: () => editarLivro(context, generosFiltrados.indexOf(livro))
                            ), 
                            IconButton( 
                            tooltip: 'Excluir', 
                              icon: const Icon(Icons.delete, color: Colors.red), 
                              onPressed: () => excluirLivro(context, generosFiltrados.indexOf(livro))
                            ), 
                          ], 
                        ), 
                        onTap: () => exibirMensagem('Você selecionou: $livro'), 
                      ); 
                    }, 
                  ), 
            ), 
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: generoSelecionado == null ? 
              [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => adicionarGenero(context),
                      icon: Icon(Icons.add),
                      label: Text("Adicionar Gênero"),
                    ),
                  ],
                )
              ] : [
               Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => adicionarGenero(context),
                    icon: Icon(Icons.add),
                    label: Text("Adicionar Gênero"),
                  ),
                ],
               ),
               SizedBox(height: 10),
               Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => editarGenero(context, generoSelecionado!),
                    icon: Icon(Icons.edit),
                    label: Text("Editar Gênero"),
                  ),
                ],
               ),
               SizedBox(height: 10),
               Row(
                children: [
                  FilledButton.icon(
                    onPressed: () => excluirGenero(context, generoSelecionado!),
                    icon: Icon(Icons.delete),
                    label: Text( "Excluir Gênero")
                  ),
                ],
               )
              ],
            )
          ],
        ),
      )
    );
  }
}