import 'package:flutter/material.dart';
import 'pages/main_page.dart';
import 'pages/list_page.dart';
import 'pages/category_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text( // Nadpis Recipe App
                'Recipe App',
                style: TextStyle(color: Colors.white), // Bílá barva textu
              ),
              Expanded( // Roztáhneme prázdný widget, aby se vyhledávací pole a ikona posunuly doprava
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Zarovnání prvků na pravou stranu
                    children: [
                      const SizedBox( // Omezíme šířku vstupního pole na 100 px
                        width: 150,
                        child: TextField(
                          style: TextStyle(color: Colors.white), // Barva textu
                          decoration: InputDecoration(
                            hintText: 'Search recipes...', // Textová nápověda
                            hintStyle: TextStyle(color: Colors.white70), // Barva textu nápovědy
                            border: InputBorder.none, // Žádné ohraničení
                          ),
                        ),
                      ),
                      IconButton( // Přidání ikony vyhledávání
                        icon: const Icon(Icons.search, color: Colors.white), // Bílá barva ikony
                        onPressed: () {
                          // Implement search functionality
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue, // Změna barvy pozadí AppBar na modrou
        ),
        body: const MainPage(),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/categories':
            return MaterialPageRoute(builder: (_) => const CategoryPage());
          case '/list':
            return MaterialPageRoute(builder: (_) => const ListPage());
          default:
            return null;
        }
      },
    );
  }
}
