import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  Stream<List<Note>> getNotes() {
    return _notes.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Note.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
  }

  Future<void> addNote(String title, String description) {
    return _notes.add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String title, String description) {
    return _notes.doc(id).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> deleteNote(String id) {
    return _notes.doc(id).delete();
  }
}
