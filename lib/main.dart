import 'package:flutter/material.dart';
import 'package:recipe_creator/screen/recipe_screen.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Color.fromRGBO(216, 139, 110,1)),
        elevatedButtonTheme: ElevatedButtonThemeData(style:ElevatedButton.styleFrom (backgroundColor:const Color.fromRGBO(175, 70, 87,1),padding: const EdgeInsets.all(10),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)) )),
        canvasColor: const Color.fromRGBO(242, 239, 234,1)
      ),
      home: RecipeScreen(),
    );
  }
}

