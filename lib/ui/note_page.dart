import 'dart:io';

import 'package:b/database/notes_db.dart';
import 'package:b/model/note.dart';
import 'package:b/ui/edit_note_page.dart';
import 'package:b/ui/note_detail_page.dart';
import 'package:b/widget/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          // backgroundColor: Colors.green.shade200,
          title: const Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await NotesDatabase().deleteDB();
                refreshNotes();
              },
              icon: const Icon(
                Icons.delete_forever,
              ),
              color: Colors.red,
            ),
            IconButton(
              onPressed: () async {
                await NotesDatabase().backupDB();
                refreshNotes();
              },
              icon: const Icon(
                Icons.copy_all,
              ),
              color: Colors.red,
            ),
            IconButton(
              onPressed: () async {
                await NotesDatabase().restoreDB();
                refreshNotes();
              },
              icon: const Icon(
                Icons.reset_tv_rounded,
              ),
              color: Colors.red,
            ),
            // IconButton(
            //   onPressed: () async {
            //     await NotesDatabase().getDbPath();
            //   },
            //   icon: const Icon(
            //     Icons.add,
            //   ),
            //   color: Colors.red,
            // ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
          ),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddEditNotePage(),
              ),
            );

            refreshNotes();
          },
        ),
      );

  // Widget buildNotes() => StaggeredGridView.countBuilder(
  //   padding: EdgeInsets.all(8),
  //   itemCount: notes.length,
  //   staggeredTileBuilder: (index) => StaggeredTile.fit(2),
  //   crossAxisCount: 4,
  //   mainAxisSpacing: 4,
  //   crossAxisSpacing: 4,
  //   itemBuilder: (context, index) {
  //     final note = notes[index];
// return GestureDetector(
//         onTap: () async {
//           await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => NoteDetailPage(noteId: note.id!),
//           ));

//           refreshNotes();
//         },
//         child: NoteCardWidget(note: note, index: index),
//       );
  //   },
  // );
  Widget buildNotes() {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        });
  }
}
