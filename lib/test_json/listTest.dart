import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class lists extends StatefulWidget {
  const lists({super.key});

  @override
  State<lists> createState() => _listsState();
}

class _listsState extends State<lists> {
  List<String> _items = [];
  late TextEditingController _textController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _items.length > 0
          ? ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${_items[index]}'),
          );
        },
      )
          : const Center(
        child: Text("You currently have no classes. Add from below."),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        spacing: 6,
        spaceBetweenChildren: 6,
        backgroundColor: const Color.fromARGB(255, 22, 37, 50),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.group_add), label: "add student"),
          SpeedDialChild(
            child: const Icon(Icons.school),
            label: "add class",
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add a new class'),
                    content: TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          hintText: "Enter the name of the class."),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('Add'),
                        onPressed: () {
                          Navigator.pop(context, _textController.text);
                        },
                      ),
                    ],
                  );
                },
              );
              if (result != null) {
                result as String;
                setState(() {
                  _items.add(result);
                });
              }
            },
          )
        ],
      ),
    );
  }
}