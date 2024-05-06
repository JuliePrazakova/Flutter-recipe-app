import 'package:flutter/material.dart';
import '../services/recipe_service.dart'; 

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: RecipeService.getCategories(), // Zavoláme metodu getCategories() ze service
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Pokud data ještě nejsou načtena, zobrazíme indikátor načítání
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Pokud došlo k chybě při načítání dat, zobrazíme chybovou zprávu
            return Center(
              child: Text('Error loading categories: ${snapshot.error}'),
            );
          } else {
            // Pokud jsou data načtena úspěšně, zobrazíme seznam kategorií
            final List<Category> categories = snapshot.data!; // Získáme seznam kategorií z snapshotu
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index].name), // Zobrazíme název kategorie
                  onTap: () {
                    // Navigate to RecipeListPage for the selected category
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
