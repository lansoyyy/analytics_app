import 'package:analytics_app/services/add_messages.dart';
import 'package:analytics_app/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../widgets/text_widget.dart';

class ChatPage extends StatefulWidget {
  String? userData;

  ChatPage({
    super.key,
    this.userData,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msgController = TextEditingController();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primary,
                  ),
                ),
                TextWidget(
                  text: 'Messages',
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                const SizedBox(
                  width: 50,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Messages')
                    .orderBy('dateTime', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print('error');
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: data.docs[index]['message'],
                                    fontSize: 14,
                                  ),
                                  TextWidget(
                                    text: DateFormat.yMMMd().add_jm().format(
                                        data.docs[index]['dateTime'].toDate()),
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.account_circle,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget(
                                        text: data.docs[index]['name'],
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: userData,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  dynamic data = snapshot.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 20),
                          child: TextFormField(
                            controller: msgController,
                            decoration: InputDecoration(
                                hintText: 'Enter message',
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    addMessage(
                                        data['name'], msgController.text);
                                    msgController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: primary,
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
