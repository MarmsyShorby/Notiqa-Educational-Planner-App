import 'package:flutter/material.dart';
import 'package:flutterapp/editor.dart';
import 'package:flutterapp/note.dart';
import 'package:flutterapp/styled_folder.dart';
import 'package:flutterapp/styled_note.dart';
import 'package:flutterapp/folder.dart';

class FolderScreen extends StatefulWidget {
  final Folder folder;
  final int Function() generateNoteId;
  final int Function() generateFolderId;

  const FolderScreen({
    super.key,
    required this.folder,
    required this.generateNoteId,
    required this.generateFolderId,
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  Future<void> _renameFolder(Folder folder) async {
    final controller = TextEditingController(text: folder.name);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rename Folder"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Folder name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                folder.name = controller.text.trim().isEmpty
                    ? "Untitled Folder"
                    : controller.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folder.name)),
      body: widget.folder.subfolders.isEmpty && widget.folder.notes.isEmpty
          ? const Center(child: Text("Folder is empty"))
          : ListView(
              children: [
                // Subfolders
                ...widget.folder.subfolders.map((subfolder) {
                  return StyledFolderTile(
                    folder: subfolder,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FolderScreen(
                            folder: subfolder,
                            generateNoteId: widget.generateNoteId,
                            generateFolderId: widget.generateFolderId,
                          ),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    onRename: () => _renameFolder(subfolder),
                  );
                }),

                // Notes
                ...widget.folder.notes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final note = entry.value;

                  return StyledNoteTile(
                    note: note,
                    onDelete: () {
                      setState(() {
                        widget.folder.notes.removeAt(index);
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Editor(
                            note: note,
                            onSave: (updated) {
                              setState(() {
                                widget.folder.notes[index] = updated;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
      floatingActionButton: PopupMenuButton<String>(
        icon: const Icon(Icons.add),
        onSelected: (value) {
          if (value == "note") {
            setState(() {
              widget.folder.notes.add(Note(id: widget.generateNoteId()));
            });
          } else if (value == "folder") {
            setState(() {
              widget.folder.subfolders.add(
                Folder(id: widget.generateFolderId(), name: "New Folder"),
              );
            });
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: "note", child: Text("New Note")),
          PopupMenuItem(value: "folder", child: Text("New Folder")),
        ],
      ),
    );
  }
}
