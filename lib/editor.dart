import 'package:flutter/material.dart';
import 'note.dart';

class Editor extends StatefulWidget {
  final Note note;
  final Function(Note) onSave;

  const Editor({super.key, required this.note, required this.onSave});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: (widget.note.title));
    bodyController = TextEditingController(text: (widget.note.text));
  }

  void saveOnPop() {
    final updatedNote = Note(
      id: widget.note.id,
      title: titleController.text,
      text: bodyController.text,
    );

    widget.onSave(updatedNote);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) saveOnPop();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: const Text("Flutter Test"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                //TITLE********
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "New Note",
                ),
                style: TextStyle(fontSize: 30),
                controller: titleController,
              ),
              Expanded(
                child: TextField(
                  //BODY********
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter notes here...",
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: bodyController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
