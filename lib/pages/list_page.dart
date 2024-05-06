import 'package:flutter/material.dart';
import '../services/recipe_service.dart'; 


class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: RecipeService.getRecipes(), // Zavoláme metodu getRecipes() ze service
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Pokud data ještě nejsou načtena, zobrazíme indikátor načítání
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Pokud došlo k chybě při načítání dat, zobrazíme chybovou zprávu
            return Center(
              child: Text('Error loading recipes: ${snapshot.error}'),
            );
          } else {
            // Pokud jsou data načtena úspěšně, zobrazíme seznam receptů
            final List<Recipe> recipes = snapshot.data!; // Získáme seznam receptů z snapshotu
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(recipes[index].name), // Zobrazíme název receptu
                  onTap: () {
                    // Navigate to RecipePage for the selected recipe
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
