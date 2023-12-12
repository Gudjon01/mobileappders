import 'package:flutter/material.dart';
import 'dart:convert';

// Define your common color here
final Color myAppColor = Colors.green; // Replace with your desired color

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Tarifleri',
      theme: ThemeData(
        primaryColor: myAppColor, // Use the common color as the primary color
      ),
      home: RecipeList(),
    );
  }
}

class Recipe {
  final String name;
  final List<String> ingredients;
  final String imagePath;

  Recipe({required this.name, required this.ingredients, required this.imagePath});
}

class RecipeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/recipes.json'),
      builder: (context, snapshot) {
        List<Recipe> recipes = [];
        if (snapshot.hasData) {
          var data = json.decode(snapshot.data.toString());
          var recipeList = data['recipes'] as List<dynamic>;

          recipes = recipeList.map((recipe) {
            return Recipe(
              name: recipe['name'],
              ingredients: List<String>.from(recipe['ingredients']),
              imagePath: recipe['image'],
            );
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Yemek Tarifleri'),
              backgroundColor: myAppColor, // Set the background color here
            ),
            body: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    recipes[index].imagePath,
                    width: 65.0,
                    height: 65.0,
                  ),
                  title: Text(recipes[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetail(recipe: recipes[index]),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  RecipeDetail({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: myAppColor, // Set the background color here
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients:',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          for (var ingredient in recipe.ingredients)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '- $ingredient',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
        ],
      ),
    );
  }
}
