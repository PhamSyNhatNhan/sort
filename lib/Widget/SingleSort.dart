import 'package:flutter/material.dart';
import 'package:sort_fu/page/HomePage.dart';

class SingleSort extends StatefulWidget {
  @override
  State<SingleSort> createState() => _SingleSortState();
}

class _SingleSortState extends State<SingleSort> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),

        Text("Trước khi sắp xếp"),
        //Text(result1.beforeSort.toString()),

        SizedBox(height: 10,),

        Text("Sau khi sắp xếp"),
        //Text(result1.afterSort.toString())
      ],
    );
  }

}