import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recipe_creator/constant/openai_key.dart';
import 'package:recipe_creator/models/openai_model.dart';
String openaiApiKey = apiKey;

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String _ingredients = '';
  String _recipe = '';
  bool _isLoading = false;

  Future<void> _generateRecipe() async {
    setState(() {
      _isLoading = true;
      _recipe = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $openaiApiKey'},
        body: json.encode({
          "model": "text-davinci-003",
          "prompt": "Write a recipe based on these ingredients with instructions:\n\n${_ingredients}",
          "temperature": 0.3,
          "max_tokens": 500,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0
        }),
      );
      String responsestatus=response.statusCode.toString();
     // print('response $responsestatus');
      //final Map<String, dynamic> data = json.decode(response.body);
      final data = recipeDataFromJson(response.body);
      //print('data $data');
      final String recipeText = data.choices[0].text;
      //print('recipeText $recipeText');
      setState(() {
        _recipe = recipeText;
      });
    } catch (e) {
      //print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Creator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 26.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _ingredients = value;
                });
              },
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.black,),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(5.0) ),
                labelText: 'Enter Ingredients',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateRecipe,

              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Generate Recipe'),
            ),
            SizedBox(height: 16.0),
            // if(_isLoading && _recipe!='')
            // Card(color:const Color.fromRGBO(255, 255, 255, 1),margin: EdgeInsets.all(8),elevation: 2,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child:
        Text(
              _recipe,
              style: TextStyle(fontSize: 16.0),
            ) ,
            
          ],
        ),
      ),
    );
  }
}