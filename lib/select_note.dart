import 'package:flutter/material.dart';
import 'package:flutterapp/styled_folder.dart';
import 'package:flutterapp/editor.dart';
import 'package:flutterapp/note.dart';
import 'package:flutterapp/folder.dart';
import 'package:flutterapp/styled_note.dart';
import 'package:flutterapp/folder_screen.dart';

class SelectNote extends StatefulWidget {
  const SelectNote({super.key});

  @override
  State<SelectNote> createState() => _SelectNoteState();
}

class _SelectNoteState extends State<SelectNote> {
  List<Folder> folders = [];
  List<Note> looseNotes = [];

  int _noteId = 1;
  int _folderId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: folders.isEmpty && looseNotes.isEmpty
          ? _buildEmptyState()
          : ListView(
              children: [
                ...folders.map(_buildFolderTile),
                ...looseNotes.map(_buildLooseNoteTile),
              ],
            ),
      floatingActionButton: _buildFabMenu(),
    );
  }

  // ================= EMPTY STATE =================

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Nothing's here, yet...",
            style: TextStyle(color: Colors.grey, fontSize: 28),
          ),
          SizedBox(height: 24),
          Icon(
            Icons.content_paste_search_rounded,
            color: Colors.grey,
            size: 120,
          ),
          SizedBox(height: 24),
          Text(
            "Use '+' to add notes or folders",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // ================= FOLDER TILE =================

  Widget _buildFolderTile(Folder folder) {
    return StyledFolderTile(
      folder: folder,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderScreen(
              folder: folder,
              generateNoteId: () => _noteId++,
              generateFolderId: () => _folderId++,
            ),
          ),
        ).then((_) => setState(() {}));
      },
      onRename: () => _renameFolder(folder),
    );
  }
  // ================= LOOSE NOTE TILE =================

  Widget _buildLooseNoteTile(Note note) {
    return StyledNoteTile(
      note: note,
      onDelete: () {
        setState(() {
          looseNotes.removeWhere((n) => n.id == note.id);
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
                  final index = looseNotes.indexWhere(
                    (n) => n.id == updated.id,
                  );
                  looseNotes[index] = updated;
                });
              },
            ),
          ),
        );
      },
    );
  }

  // ================= RENAME FOLDER =================

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

  // ================= FAB MENU =================

  Widget _buildFabMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.add_circle, size: 40),
      onSelected: (value) {
        if (value == "note") {
          setState(() {
            looseNotes.add(Note(id: _noteId++));
          });
        } else if (value == "folder") {
          setState(() {
            folders.add(Folder(id: _folderId++, name: "New Folder"));
          });
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: "note", child: Text("New Note")),
        PopupMenuItem(value: "folder", child: Text("New Folder")),
      ],
    );
  }
}
