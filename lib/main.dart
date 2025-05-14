import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecetApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Recipe>> getAllRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s='));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return List<Recipe>.from(
          data['meals'].map((meal) => Recipe.fromJson(meal)),
        );
      } else {
        return [];
      }
    } else {
      throw Exception('Error al obtener las recetas');
    }
  }

  static Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] != null) {
        return List<Recipe>.from(
          data['meals'].map((meal) => Recipe.fromJson(meal)),
        );
      } else {
        return [];
      }
    } else {
      throw Exception('Error al buscar recetas');
    }
  }
}

class Recipe {
  final String id;
  final String name;
  final String description;
  final String categoria;
  final String area;
  final String imageUrl;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.categoria,
    required this.area,
    required this.imageUrl,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients.add(ingredient);
      }
    }

    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'] ?? '',
      description: json['strInstructions'] ?? '',
      categoria: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      ingredients: ingredients,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchPage(),
    const RecipeGridPage(),
    const FavoritesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RecetApp')),
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F1F1F), // Fondo oscuro
        selectedItemColor: Colors.deepOrange, // Color activo
        unselectedItemColor: Colors.grey, // Color inactivo
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Recetas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('assets/images/home.png'),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Color(0xFF121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: FadeIn(
          duration: const Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                '¡Bienvenido a RecetApp!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),

              BounceInDown(
                duration: const Duration(milliseconds: 1400),
                child: Image.asset(
                  'assets/images/home.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Explora miles de recetas deliciosas\n¡y aprende a cocinar como un chef!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black38,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Cambia a la pestaña de Recetas (índice 2)
                  final homeState =
                      context.findAncestorStateOfType<_HomePageState>();
                  homeState?._onItemTapped(2);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Explorar Recetas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteRecipes {
  static final List<Recipe> _favorites = [];

  static List<Recipe> get favorites => _favorites;

  static void toggleFavorite(Recipe recipe) {
    if (_favorites.any((r) => r.id == recipe.id)) {
      _favorites.removeWhere((r) => r.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
  }

  static bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Recipe> _results = [];
  bool _isLoading = false;

  void _search() async {
    setState(() {
      _isLoading = true;
    });

    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      try {
        final recipes = await ApiService.searchRecipes(query);
        setState(() {
          _results = recipes;
        });
      } catch (_) {
        setState(() {
          _results = [];
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Buscar receta',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _search,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_results.isEmpty)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.fastfood, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay recetas disponibles',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final recipe = _results[index];
                  return ZoomIn(
                    // <--- Aquí aplicamos la animación
                    duration: Duration(milliseconds: 300 + index * 100),
                    child: ListTile(
                      title: Text(recipe.name),
                      subtitle: Text('${recipe.categoria} • ${recipe.area}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                            pageBuilder:
                                (_, animation, __) => FadeTransition(
                                  opacity: animation,
                                  child: RecipeDetailPage(recipe: recipe),
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class RecipeGridPage extends StatefulWidget {
  const RecipeGridPage({super.key});

  @override
  State<RecipeGridPage> createState() => _RecipeGridPageState();
}

class _RecipeGridPageState extends State<RecipeGridPage> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final data = await ApiService.getAllRecipes();
      setState(() {
        _recipes = data;
      });
    } catch (_) {
      setState(() => _recipes = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.fastfood, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay recetas disponibles',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: recipe),
              ),
            );
          },
          child: FadeInUp(
            duration: Duration(milliseconds: 400 + index * 100),
            child: Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      recipe.imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.categoria,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          recipe.area,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteRecipes.favorites;

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.fastfood, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tienes recetas favoritas',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final recipe = favorites[index];
        return ListTile(
          title: Text(recipe.name),
          subtitle: Text('${recipe.categoria} • ${recipe.area}'),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Color.from(
                alpha: 1,
                red: 0.957,
                green: 0.263,
                blue: 0.212,
              ),
            ),
            onPressed: () async {
              // Mostrar diálogo de confirmación
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Eliminar receta'),
                      content: Text(
                        '¿Quieres eliminar "${recipe.name}" de tus favoritos?',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: const Text('Eliminar'),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
              );

              // Si el usuario confirmó, eliminar y mostrar SnackBar
              if (confirm == true) {
                setState(() {
                  FavoriteRecipes.toggleFavorite(recipe);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Se eliminó "${recipe.name}" de favoritos'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.deepOrange,
                  ),
                );
              }
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailPage(recipe: recipe),
              ),
            ).then((_) => setState(() {})); // refresca al volver
          },
        );
      },
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: Icon(
              FavoriteRecipes.isFavorite(recipe.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              FavoriteRecipes.toggleFavorite(recipe);
              (context as Element).markNeedsBuild(); // refresca el widget
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              // Imagen
              child: Image.network(recipe.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            FadeInRight(
              child: Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeIn(child: Text(recipe.description)),
            const SizedBox(height: 16),
            const Text(
              'Ingredientes:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...recipe.ingredients.map(
              (ing) => FadeInLeft(child: Text("• $ing")),
            ),
          ],
        ),
      ),
    );
  }
}
