import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'list_page.dart'; // Import the recipe provider

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController(); // Controller for the search text field

    return AppBar(
      title: GestureDetector(
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
      actions: [
       IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (searchController.text.trim().isEmpty) return;
            Navigator.push(context, MaterialPageRoute(builder: (_) => ListPage(searchTerm: searchController.text)));

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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
