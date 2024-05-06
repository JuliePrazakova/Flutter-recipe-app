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
              const Text( 
                'Recipe App',
                style: TextStyle(color: Colors.white), 
              ),
              Expanded( 
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, 
                    children: [
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
                      IconButton( 
                        icon: const Icon(Icons.search, color: Colors.white), 
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
          backgroundColor: Colors.blue, 
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
