import 'package:flutter/material.dart';
import './screens/categories_screen.dart';
import './screens/meal_screen.dart';
import './screens/meal_detail_sreen.dart';
import './screens/tabs_screen.dart';
import './screens/filters_screen.dart';
import './models/meal.dart';
import './dummy-data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  //How a state should change?
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    //available meals are set to all meals first and are filtered thru this function
    setState(() {
      _filters =
          filterData; //filterData is from the screen that actually calls this function and passed it as results

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFav(String id) {
    //this funtion controls what will happen when click that fav icon

    final existingIndex = _favoritedMeals.indexWhere((meal) => meal.id == id);
    if (existingIndex < 0) {
      setState(() {
        _favoritedMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == id));
      });
    } else if (existingIndex >= 0) {
      setState(() {
        _favoritedMeals.removeAt(existingIndex);
      });
    }
  }

  bool _isFaved(String id) {
    //this funtion controls what kind of fav icon should show on screen
    return _favoritedMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          accentColor: Color.fromRGBO(228, 159, 99, 1),
          canvasColor: Color.fromRGBO(255, 238, 222, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                ),
              )),
      routes: {
        '/': (ctx) => TabScreen(
              _favoritedMeals,
            ),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(
              _availableMeals,
            ),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(
              _toggleFav,
              _isFaved,
            ),
        FilterScreen.routeName: (ctx) => FilterScreen(
              _filters,
              _setFilters,
            ),
      },
      onUnknownRoute: (setting) {
        // when can't render anything, go to this page, like 'oh this page doesn't exist'
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen(),
        );
      },
    );
  }
}
