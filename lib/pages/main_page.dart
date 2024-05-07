import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
import './list_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to our recipe application!s'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display featured recipe
            // Display subset of recipe categories
            FutureBuilder<List<Category>>(
              future: RecipeService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Placeholder for loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error loading categories: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Wrap(
                    spacing: 8.0, // Adjust spacing between buttons
                    children: snapshot.data!.map((category) {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListPage(category: category),
                            ),
                          );                        },
                        child: Text(category.name),
                      );
                    }).toList(),
                  );
                } else {
                  return const Text('No categories found'); // Placeholder for no data
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
