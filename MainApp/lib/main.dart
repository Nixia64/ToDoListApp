import 'package:dart_tp_note/consts.dart';
import 'package:dart_tp_note/database.dart';
import 'package:dart_tp_note/pages/add_category.dart';
import 'package:dart_tp_note/pages/edit_category.dart';
import 'package:dart_tp_note/pages/task_list.dart';
import 'package:dart_tp_note/repositories/category.dart';
import 'package:dart_tp_note/repositories/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/category.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TodoLDB().open();
  runApp(ChangeNotifierProvider(
      create: (context) => CategoryRepository(),
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});
  final categoryRepo = CategoryRepository();
  final taskRepo = TaskRepository();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Category>> _categoryList;

  _deleteCategory(Category category) {
    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Supprimer une catégorie'),
            content: Text('Supprimer la catégorie $category ?'),
            actions: [
              TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop()
                  },
                  child: const Text('Non')
              ),
              TextButton(
                  onPressed: () => {
                    widget.categoryRepo.delete(category),
                    setState(() {
                      _categoryList = widget.categoryRepo.getAll();
                    }),
                    Navigator.of(context).pop()
                  },
                  child: const Text('Oui')
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _categoryList = widget.categoryRepo.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(appTitle),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          color: Colors.white
        ),
      ),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: FutureBuilder(
                  future: _categoryList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) =>
                              GestureDetector(
                                onTap: () => Navigator.of(context).
                                push(MaterialPageRoute(builder: (context) => TaskList(category: data[index]))).
                                then((value) => setState(() {
                                  _categoryList = widget.categoryRepo.getAll();
                                })),
                                child: Card(
                                  child: Padding(padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data[index].name),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('${data[index].count.toString()} tâches'),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () => Navigator.of(context).
                                                    push(MaterialPageRoute(builder: (context) => EditCategory(category: data[index]))).
                                                    then((value) => setState(() {
                                                      _categoryList = widget.categoryRepo.getAll();
                                                    })),
                                                    icon: const Icon(Icons.edit),
                                                ),
                                                IconButton(
                                                    onPressed: () => _deleteCategory(data[index]),
                                                    icon: const Icon(Icons.delete)
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              )
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              ))
            ],
          ))
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: () => Navigator.of(context).
          push(MaterialPageRoute(builder: (context) => AddCategory())).
          then((value) => setState(() {
                _categoryList = widget.categoryRepo.getAll();
          })),
          child: const Icon(Icons.add),
      ),
    );
  }
}
