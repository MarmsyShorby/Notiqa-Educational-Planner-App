import 'package:flutter/material.dart';
import 'editor.dart';
import 'note.dart';

// ===================== FOLDER MODEL =====================

class Folder {
  final int id;
  String name;
  List<Note> notes;

  Folder({required this.id, required this.name, List<Note>? notes})
    : notes = notes ?? [];
}

// ===================== MAIN SELECT SCREEN =====================

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

  // ---------------- EMPTY STATE ----------------

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

  // ---------------- FOLDER TILE ----------------

  Widget _buildFolderTile(Folder folder) {
    return ListTile(
      leading: const Icon(Icons.folder, color: Colors.amber),
      title: Text(folder.name),
      trailing: Text("${folder.notes.length}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FolderScreen(folder: folder, generateNoteId: () => _noteId++),
          ),
        ).then((_) => setState(() {}));
      },
    );
  }

  // ---------------- LOOSE NOTE TILE ----------------

  Widget _buildLooseNoteTile(Note note) {
    return ListTile(
      title: Text(note.title.isEmpty ? "New Note" : note.title),
      subtitle: Text(
        note.text.isEmpty ? "Enter your notes here..." : note.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          setState(() {
            looseNotes.removeWhere((n) => n.id == note.id);
          });
        },
      ),
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

  // ---------------- FAB MENU ----------------

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
      itemBuilder: (context) => const [
        PopupMenuItem(value: "note", child: Text("New Note")),
        PopupMenuItem(value: "folder", child: Text("New Folder")),
      ],
    );
  }
}

// ===================== FOLDER SCREEN =====================

class FolderScreen extends StatefulWidget {
  final Folder folder;
  final int Function() generateNoteId;

  const FolderScreen({
    super.key,
    required this.folder,
    required this.generateNoteId,
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folder.name)),
      body: widget.folder.notes.isEmpty
          ? const Center(child: Text("Folder is empty"))
          : ListView.builder(
              itemCount: widget.folder.notes.length,
              itemBuilder: (context, index) {
                final note = widget.folder.notes[index];

                return ListTile(
                  title: Text(note.title.isEmpty ? "New Note" : note.title),
                  subtitle: Text(
                    note.text.isEmpty ? "Enter your notes here..." : note.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        widget.folder.notes.removeAt(index);
                      });
                    },
                  ),
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
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            widget.folder.notes.add(Note(id: widget.generateNoteId()));
          });
        },
      ),
    );
  }
}
