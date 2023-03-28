import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data?.docs ?? [];
        final uid = FirebaseAuth.instance.currentUser?.uid;

        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (ctx, index) => Container(
            padding: const EdgeInsets.all(8.0),
            child: MessageBubble(
              documents[index]['text'],
              documents[index]['username'],
              documents[index]['userImage'],
              documents[index]['userId'] == uid,
              key: ValueKey(documents[index].id),
            ),
          ),
        );
      },
    );
  }
}
