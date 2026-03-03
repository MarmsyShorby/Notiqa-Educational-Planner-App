import 'package:flutter/material.dart';
import 'package:flutterapp/folder.dart';

class StyledFolderTile extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback onRename;

  const StyledFolderTile({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = folder.notes.length + folder.subfolders.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.folder, color: Colors.amber, size: 30),
        title: Text(
          folder.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "$itemCount items",
          style: const TextStyle(fontSize: 12),
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: onRename,
        ),
      ),
    );
  }
}
