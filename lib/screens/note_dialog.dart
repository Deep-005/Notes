import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NoteDialog extends StatefulWidget {
  const NoteDialog({
    super.key,
    this.noteId,
    this.title,
    this.description,
    required this.onNoteSaved
  });

  final int? noteId;
  final String? title;
  final String? description;
  final Function onNoteSaved;

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {



  @override
  Widget build(BuildContext context) {

    final titleController = TextEditingController(text: widget.title);
    final descriptionController = TextEditingController(text: widget.description);
    final currentDate = DateFormat('yyyy mm dd').format(DateTime.now());

    return AlertDialog(
      backgroundColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.deepPurple.shade300)
      ),
      shadowColor: Colors.deepPurple.shade100,
      title: Text(
        widget.noteId == null ? 'Add Note' : 'Edit Note',
        style: TextStyle(
          color: Colors.deepPurple.shade400,
          fontWeight: FontWeight.bold
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

              Text(
                currentDate,
                style: TextStyle(
                  color: Colors.purple.shade400,
                  fontSize: 14
                ),
              ),

              SizedBox(height: 16,),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                  )
                ),
              ),

              SizedBox(height: 16,),

              TextField(
                controller: descriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    labelText: 'Content',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none
                    )
                ),
              ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              shadowColor: Colors.white
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600
              ),
            )
        ),
        ElevatedButton(
          onPressed: () async {
            final newTitle = titleController.text;
            final newDescription = descriptionController.text;
            widget.onNoteSaved(newTitle, newDescription, currentDate);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.deepPurple.shade300,
          ),
          child: Text(
            'Save',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        )      ],
    );
  }
}

