import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../screens/meal_detail_sreen.dart';

//each meal item that shows in meal page where has image that you can click to see more details
class MealItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  MealItem({
    @required this.id,
    @required this.title,
    @required this.affordability,
    @required this.complexity,
    @required this.duration,
    @required this.imageUrl,
  });

  String get AffordabilityText {
    // the data type is initiated as enum so it has to use getter to get the plain text
    if (affordability == Affordability.Affordable) {
      return 'Affordable';
    } else if (affordability == Affordability.Pricey) {
      return 'Pricey';
    } else if (affordability == Affordability.Luxurious) {
      return 'Luxurious';
    } else {
      return 'Unknown';
    }
  }

  String get ComplexityText {
    if (complexity == Complexity.Simple) {
      return 'Simple';
    } else if (complexity == Complexity.Challenging) {
      return 'Challenging';
    } else if (complexity == Complexity.Hard) {
      return 'Hard';
    } else {
      return 'Unknown';
    }
  }

  void selectMeal(BuildContext context) {
    Navigator.of(context).pushNamed(
      MealDetailScreen.routeName,
      arguments: id, //pass id to the route
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context), //should tap to see its recipe
      child: Card(
          shape: RoundedRectangleBorder(
            //so the card is rounded cornered
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Stack(
                //where you can put widget on top of other widgets
                children: <Widget>[
                  ClipRRect(
                    //picture that its corner should be re-shaped as rounded-cornered as its mother card
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    // this widget is only available in stack, to style the text on the pic
                    bottom: 20,
                    right: 10,
                    child: Container(
                      width: 300,
                      color: Colors.black26, //black with 26% opacity
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                        softWrap: true, // for safety
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround, // to add some space between icons
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.schedule),
                          SizedBox(
                            // add some random space between icon and text
                            width: 6,
                          ),
                          Text(
                              '$duration min'), //all other data is in enum data type so should use a getter while this is just a varable stored in db
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.work),
                          SizedBox(
                            width: 6,
                          ),
                          Text(ComplexityText),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.attach_money),
                          SizedBox(
                            width: 6,
                          ),
                          Text(AffordabilityText),
                        ],
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
