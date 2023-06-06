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
          "max_tokens": 120,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0
        }),
      );
      String responsestatus=response.statusCode.toString();
      print('response $responsestatus');
      //final Map<String, dynamic> data = json.decode(response.body);
      final data = recipeDataFromJson(response.body);
      print('data $data');
      final String recipeText = data.choices[0].text;
      print('recipeText $recipeText');
      setState(() {
        _recipe = recipeText;
      });
    } catch (e) {
      print('Error: $e');
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
            TextField(
              onChanged: (value) {
                setState(() {
                  _ingredients = value;
                });
              },
              decoration: InputDecoration(
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
            Text(
              _recipe,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}