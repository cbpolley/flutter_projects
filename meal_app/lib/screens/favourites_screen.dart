import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../widgets/meal_item.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Meal> favouritedMeals;

  FavouritesScreen(this.favouritedMeals);

  @override
  Widget build(BuildContext context) {
    if (favouritedMeals.isEmpty) {
      return Center(
        child: Text('You haven\'t got any favourites yet!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          return MealItem(
            id: favouritedMeals[index].id,
            title: favouritedMeals[index].title,
            imageUrl: favouritedMeals[index].imageUrl,
            duration: favouritedMeals[index].duration,
            affordability: favouritedMeals[index].affordability,
            complexity: favouritedMeals[index].complexity,
          );
        },
        itemCount: favouritedMeals.length,
      );
    }
  }
}
