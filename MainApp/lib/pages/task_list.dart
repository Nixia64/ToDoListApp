import 'package:dart_tp_note/model/category.dart';
import 'package:dart_tp_note/repositories/category.dart';
import 'package:dart_tp_note/repositories/task.dart';
import 'package:flutter/material.dart';
import '../model/task.dart';

class TaskList extends StatefulWidget {
  TaskList({required this.category, super.key});

  final taskRepository = TaskRepository();
  final categoryRepo = CategoryRepository();
  final Category category;

  @override
  State<StatefulWidget> createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  late Future<List<Task>> _list;
  late TextEditingController _textInput;

  @override
  void initState() {
    super.initState();
    _list = widget.taskRepository.getAll(widget.category);
    _textInput = TextEditingController();
  }

  _addTask() async {
    try {
      await widget.taskRepository.insert(Task(
          name: _textInput.text,
          category_id: widget.category.id!,
      ));
      await widget.categoryRepo.update(Category(
          id: widget.category.id,
          name: widget.category.name,
          count: await widget.taskRepository.getCount(widget.category)
      ));
      setState(() {
        _list = widget.taskRepository.getAll(widget.category);
      });
      _textInput.clear();
    } catch (e) {}
  }

  _setOver(Task task, bool value) async {
    if (task.over) {
      try {
        await widget.taskRepository.update(Task(
            id: task.id,
            name: task.name,
            over: false,
            category_id: widget.category.id!
        ));
        setState(() {
          _list = widget.taskRepository.getAll(widget.category);
        });
      } catch (e) {}
    } else {
      try {
        await widget.taskRepository.update(Task(
            id: task.id,
            name: task.name,
            over: true,
            category_id: widget.category.id!
        ));
        setState(() {
          _list = widget.taskRepository.getAll(widget.category);
        });
      } catch (e) {}
    }
  }

  _deleteTask(Task task) async {
    try {
      await widget.taskRepository.delete(task);
      await widget.categoryRepo.update(Category(
          id: widget.category.id,
          name: widget.category.name,
          count: await widget.taskRepository.getCount(widget.category)
      ));
      setState(() {
        _list = widget.taskRepository.getAll(widget.category);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text(widget.category.name),
            titleTextStyle: const TextStyle(
                fontSize: 24,
                color: Colors.white
            ),
        ),
        body: Padding(padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ValueListenableBuilder(
                  valueListenable: _textInput,
                  builder: (context, TextEditingValue value, __) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: TextField(
                              autofocus: true,
                              controller: _textInput,
                              decoration: const InputDecoration(
                                hintText: 'Ajouter',
                              ),
                            )
                        ),
                        IconButton(
                            onPressed: _textInput.value.text.isNotEmpty ? _addTask : null,
                            icon: const Icon(Icons.add))
                      ],
                    );
                  }
              ),
              Expanded(
                child: FutureBuilder(
                  future: _list,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) =>
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        hoverColor: Colors.green,
                                        focusColor: Colors.green,
                                        activeColor: Colors.green,
                                        value: data[index].over,
                                        onChanged: (bool? value) {
                                          _setOver(data[index], value!);
                                        }
                                    ),
                                    Text(data[index].name),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () => _deleteTask(data[index]),
                                    icon: const Icon(Icons.indeterminate_check_box_outlined))
                              ],
                            )
                      );
                    } else {
                      return const Center(child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator()));
                    }
                  }
                )
              )
            ],
          )
        )
      )
    );
  }
}