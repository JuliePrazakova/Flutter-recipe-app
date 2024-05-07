import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          if (ModalRoute.of(context)!.settings.name != '/') {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
        child: const MouseRegion(
          cursor: SystemMouseCursors.click, // Změna kurzoru na packu
          child: Text(
            'Recipe App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      centerTitle: true, // Zarovnat název na střed
      backgroundColor: Colors.blue,
      iconTheme: const IconThemeData(color: Colors.white), // Barva šipky zpět
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Implement search functionality
          },
        ),
        const SizedBox(
          width: 150,
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
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
