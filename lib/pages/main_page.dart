import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        // Add search functionality to the app bar
        // You can use a SearchBar widget or IconButton for search icon
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to the search page
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display featured recipe
            // Display subset of recipe categories
            // Add links to other pages (e.g., recipe category page)
          ],
        ),
      ),
    );
  }
}
