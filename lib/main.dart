import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'pages/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';



void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final snapshot = await _firestore.collection('recipes').get();
  snapshot.docs.forEach((doc) => print('${doc.id}: ${doc.data()}'));

  runApp(ProviderScope(child: RecipeApp()));

}

class RecipeApp extends ConsumerWidget {
  const RecipeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider);

    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar:  const MyAppBar(),
        body: asyncUser.when(
        data: (user) {
          return user == null ? LoginPage() : const MainPage();
        },
        error: (error, stackTrace) {
          return const Center(child: Text("Something went wrong.."));
        },
        loading: () {
          return const Center(child: Text("Loading..."));
        },
      ),
      ),
    );
  }
}
