import 'package:flutterapp/note.dart';

class Folder {
  final int id;
  String name;

  List<Note> notes;
  List<Folder> subfolders;

  Folder({
    required this.id,
    required this.name,
    List<Note>? notes,
    List<Folder>? subfolders,
  }) : notes = notes ?? [],
       subfolders = subfolders ?? [];
}