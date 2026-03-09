import 'package:flutterapp/drawing_board.dart';
import 'package:flutterapp/folder.dart';
import 'package:flutterapp/note.dart';

class AccountInformation {
  String username;
  String email;
  String password;

  AccountInformation({
    required this.username,
    required this.email,
    required this.password,
  });
}

class AccountStorageData {
  List<Folder> folders;
  List<Note> looseNotes;
  List<DrawingStroke> strokes;
  List<StickyNote> notes;

  AccountStorageData({
    List<Folder>? folders,
    List<Note>? looseNotes,
    List<DrawingStroke>? strokes,
    List<StickyNote>? notes,
  }) : folders = folders ?? [],
       looseNotes = looseNotes ?? [],
       strokes = strokes ?? [],
       notes = notes ?? [];
}

final Map<String, AccountStorageData> accountTiedData = {};

String? currentAccountId;
AccountStorageData? currentAccountStorageData;

void login(String username) {
  currentAccountId = username;
  currentAccountStorageData = accountTiedData[username] ?? AccountStorageData();
}

void logout() {
  if (currentAccountId != null) {
    accountTiedData[currentAccountId!] = currentAccountStorageData!;
  }
  currentAccountId = null;
  currentAccountStorageData = null;
}
