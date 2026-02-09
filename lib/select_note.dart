import 'package:flutter/material.dart';
import 'editor.dart';
import 'note.dart';

class SelectNote extends StatefulWidget {
  const SelectNote({super.key});

  @override
  State<SelectNote> createState() => _SelectNote();
}

class _SelectNote extends State<SelectNote> {
  List<Note> notes = [];
  int _noteId = 1;

  bool get isNoteListEmpty => notes.isEmpty;

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },

        child: notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Nothing's here, yet...",
                      style: TextStyle(color: Colors.grey, fontSize: 30),
                    ),
                    SizedBox(height: 24),
                    Icon(
                      Icons.content_paste_search_rounded,
                      color: Colors.grey,
                      size: 140,
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Use the '+' button to add notes",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, index) {
                  final note = notes[index].id; //

                  return Padding(
                    padding: const EdgeInsets.all(16.0),

                    child: InkWell(
                      onTap: () async {
                        //GO TO EDITOR-----------
                        final updatedNote = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Editor(
                              note: notes[index],
                              onSave: (updatedNote) {
                                setState(() {
                                  notes[index] = updatedNote;
                                });
                              },
                            ),
                          ),
                        );

                        if (updatedNote != null) {}
                      },

                      child: Container(
                        //note element widget-----------
                        key: ValueKey(note),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          //NOTES RrRENDERING-----------
                          children: [
                            //TITLE-----------
                            Expanded(
                              flex: 1,
                              child: Text(
                                notes[index].title.isEmpty
                                    ? "New Note"
                                    : notes[index].title,
                              ),
                            ),

                            //BODY TEXT-----------
                            Expanded(
                              flex: 2,
                              child: Text(
                                notes[index].text.isEmpty
                                    ? "Enter your notes here..."
                                    : notes[index].text,
                                style: TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(width: 10), //PADDING-----------
                            //TRASH BUTTON-----------

                            //ADD CONFIRMATION WHEN TAPPING TRASH TO BE DONE
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  //USE NOTE ID TO DELETE NOTE
                                  notes.removeWhere((n) => n.id == note);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_to_photos),
        onPressed: () {
          setState(() {
            notes.add(Note(id: _noteId++));
          });
        },
      ),
    );
  }
}
