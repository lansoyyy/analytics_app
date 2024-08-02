import 'package:analytics_app/screens/chat_page.dart';
import 'package:analytics_app/utils/colors.dart';
import 'package:analytics_app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final searchController = TextEditingController();

  String nameSearched = '';

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 1,
        backgroundColor: primary,
        title: TextWidget(
          text: 'Messages',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Regular', fontSize: 14),
                  onChanged: (value) {
                    setState(() {
                      nameSearched = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(fontFamily: 'QRegular'),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      )),
                  controller: searchController,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .where('id',
                      isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        userData: data.docs[index].id,
                                      )));
                            },
                            child: ListTile(
                              leading: const Icon(
                                Icons.account_circle_rounded,
                                size: 50,
                              ),
                              title: TextWidget(
                                text: data.docs[index]['name'],
                                fontSize: 18,
                                fontFamily: 'Bold',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .where('freelancerId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        userData: data.docs[index].id,
                                      )));
                            },
                            child: ListTile(
                              leading: const Icon(
                                Icons.account_circle_rounded,
                                size: 50,
                              ),
                              title: TextWidget(
                                text: data.docs[index]['userName'],
                                fontSize: 18,
                                fontFamily: 'Bold',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      )),
    );
  }
}
