import 'package:bg4102_software/Utilities/customAppbar.dart';
import 'package:bg4102_software/Utilities/customDrawer.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recordpage extends StatefulWidget {
  const Recordpage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecordpageState createState() => _RecordpageState();
}

class _RecordpageState extends State<Recordpage> {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _results =
      FirebaseFirestore.instance.collection('Results');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        title: 'Records',
        fontSize: 25,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushNamed(homePageRoute);
            },
          ),
        ],
        leading: null,
      ),
      body: StreamBuilder(
        stream: _results.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['DatenTime']),
                    subtitle: Text(documentSnapshot['Result']),
                  ),
                );
              },
            );
          }
          // ignore: dead_code
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
