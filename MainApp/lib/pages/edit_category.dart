import 'package:dart_tp_note/components.dart';
import 'package:dart_tp_note/model/category.dart';
import 'package:dart_tp_note/repositories/category.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  EditCategory({required this.category, super.key});

  final categoriesRepo = CategoryRepository();
  final Category category;

  @override
  State<StatefulWidget> createState() => EditCategoryPageState();
}

class EditCategoryPageState extends State<EditCategory> {
  final _formKey = GlobalKey<FormState>();
  late String _textInput;

  _editCategory() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();

    try {
      widget.categoriesRepo.update(Category(
          id: widget.category.id,
          name: _textInput,
          count: widget.category.count
      ));
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
            title: const Text('Modifier'),
            titleTextStyle: const TextStyle(
                fontSize: 24,
                color: Colors.white
            ),
        ),
        body: Padding(padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    initialValue: widget.category.name,
                    onSaved: (value) => _textInput = value.toString(),
                    validator: (value) => stringNotEmptyValidator(value, 'Le nom n\'est pas valide'),
                    decoration: const InputDecoration(
                        hintText: 'Nouveau nom'
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _editCategory,
                        child: const Text('Modifier')),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

}