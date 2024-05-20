import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'list_page.dart';
import 'breakpoints.dart';

final searchTermProvider = StateProvider<String>((ref) => '');

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final TextEditingController searchController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return SizedBox(
      height: kToolbarHeight, // Limiting the height of AppBar
      child: AppBar(
        title: size.width < Breakpoints.sm
            ? null // Do not show the text if width is less than breakpoints.sm
            : GestureDetector(
                onTap: () {
                  if (ModalRoute.of(context)!.settings.name != '/') {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                },
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    'Recipe App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: _isMainPage(context)
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (ModalRoute.of(context)!.settings.name != '/') {
                    Navigator.pushNamed(context, '/');
                  }
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ref
                  .watch(searchTermProvider.notifier)
                  .update((state) => searchController.text);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ListPage()));

              Future.delayed(Duration.zero, () {
                searchController.clear();
              });
            },
          ),
          SizedBox(
            width: 150,
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search recipes...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
          if (auth.currentUser != null)
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/user');
              },
            ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  bool _isMainPage(BuildContext context) {
    // Check if the current page is MainPage
    return ModalRoute.of(context)!.settings.name == '/';
  }
}
