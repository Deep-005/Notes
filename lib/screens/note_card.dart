import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.onDelete, required this.onTap});

  final Map<String, dynamic> note;
  final Function onDelete;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.deepPurple.shade300)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              note['date'],
              style: TextStyle(
                color: Colors.deepPurple.shade400,
                fontSize: 12
              ),
            ),

            SizedBox(height: 8,),

            Text(
              note['title'],
              style: TextStyle(
                  color: Colors.deepPurple.shade400,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 8,),

            Expanded(
                child: Text(
                  note['description'],
                  style: TextStyle(
                      color: Colors.white,
                      height: 1.5,
                      fontWeight: FontWeight.normal
                  ),
                  overflow: TextOverflow.fade,
                ),
            ),

            SizedBox(height: 8,),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => onDelete(),
                    icon: Icon(Icons.delete_outline, color: Colors.white, size: 20,)
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
