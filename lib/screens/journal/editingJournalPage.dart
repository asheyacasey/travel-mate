import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:travel_mate/screens/journal/journal.dart';
import 'package:travel_mate/screens/journal/journal_data.dart';

import '../../widgets/widgets.dart';

class EditingJournalPage extends StatefulWidget {
  Journal journal;
  bool isNewJournal;

  EditingJournalPage({
    super.key,
    required this.journal,
    required this.isNewJournal,
  });

  @override
  State<EditingJournalPage> createState() => _EditingJournalPageState();
}

class _EditingJournalPageState extends State<EditingJournalPage> {
  QuillController _controller = QuillController.basic();

  void initState() {
    super.initState();
    loadExistingJournal();
  }

  //laod existing journal
  void loadExistingJournal() {
    final doc = Document()..insert(0, widget.journal.text);
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  //adding a new journal
  void addNewJournal() {
    //get new id
    int id = Provider.of<JournalData>(context, listen: false)
        .getAllJournals()
        .length;
    //get text from editor
    String text = _controller.document.toPlainText();
    //add the new note
    Provider.of<JournalData>(context, listen: false).addNewJournal(
      Journal(id: id, text: text),
    );
  }

  //updating existing note
  void updateJournal() {
    //get text from editor
    String text = _controller.document.toPlainText();
    //update journal
    Provider.of<JournalData>(context, listen: false)
        .updateJournal(widget.journal, text);
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color(0xFFB0DB2D);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //if new journal
            if (widget.isNewJournal && !_controller.document.isEmpty()) {
              addNewJournal();
            }
            //if it's an existing journal
            else {
              updateJournal();
            }

            Navigator.pop(context);
          },
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          //toolbar
          QuillToolbar.basic(
            controller: _controller,
            showAlignmentButtons: false,
            showBackgroundColorButton: false,
            showCenterAlignment: false,
            showCodeBlock: false,
            showColorButton: false,
            showDirection: false,
            showDividers: false,
            showFontFamily: false,
            showFontSize: false,
            showIndent: false,
            showInlineCode: false,
            showHeaderStyle: false,
            showItalicButton: false,
            showBoldButton: false,
            showJustifyAlignment: false,
            showLeftAlignment: false,
            showLink: false,
            showClearFormat: false,
            showListBullets: false,
            showListCheck: false,
            showListNumbers: false,
            showQuote: false,
            showRightAlignment: false,
            showSearchButton: false,
            showSmallButton: false,
            showStrikeThrough: false,
            showSubscript: false,
            showSuperscript: false,
            showUnderLineButton: false,
          ),

          //editor
          Expanded(
            child: Container(
              padding: EdgeInsets.all(25),
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
