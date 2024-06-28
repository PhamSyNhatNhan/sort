import 'package:flutter/material.dart';
import 'package:sort_fu/Card/SortCard2.dart';
import 'package:sort_fu/page/HomePage.dart';

class MultiSort extends StatefulWidget {
  @override
  State<MultiSort> createState() => _MultiSortState();
}

class _MultiSortState extends State<MultiSort> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //color: Colors.blue,
              width: (MediaQuery.of(context).size.width - 40) * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < listResult.length; i+=2)
                    Column(
                      children: [
                        SortCard2(result: listResult[i]),
                        SizedBox(height: 20,),
                      ],
                    ),
                ],
              ),
            ),

            Container(
              //color: Colors.yellow,
              width: (MediaQuery.of(context).size.width - 40) * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i < listResult.length; i+=2)
                    Column(
                      children: [
                        SortCard2(result: listResult[i]),
                        SizedBox(height: 20,),
                      ],
                    ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}