import 'package:dart_tp_note/components.dart';
import 'package:dart_tp_note/model/category.dart';
import 'package:dart_tp_note/repositories/category.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  AddCategory({super.key});
  final categoriesRepo = CategoryRepository();

  @override
  State<StatefulWidget> createState() => AddCategoryState();
}

class AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  late String _textInput;

  _addCategory() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();

    try {
      widget.categoriesRepo.insert(Category(
          name: _textInput));
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey,
            title: const Text('Nouvelle catégorie'),
            titleTextStyle: const TextStyle(
                fontSize: 24,
                color: Colors.white
            ),
        ),
        body: Padding(padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey ,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  onSaved: (value) => _textInput = value.toString(),
                  validator: (value) => stringNotEmptyValidator(value, 'Le nom n\'est pas valide'),
                  decoration: const InputDecoration(
                      hintText: 'Nouvelle catégorie',
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _addCategory,
                      child: const Text('Ajouter')),
                )
              ],
            ),
          )
        ),
    ));
  }

}