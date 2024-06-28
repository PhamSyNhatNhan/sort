import 'package:flutter/material.dart';
import 'package:sort_fu/page/HomePage.dart';

import '../Class/Result.dart';

class SortCard2 extends StatefulWidget {
  final Result result;
  SortCard2({required this.result});

  @override
  State<SortCard2> createState() => _SortCard2State();
}

class _SortCard2State extends State<SortCard2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(1, 2),
          ),
        ],
      ),
      width: (MediaQuery.of(context).size.width - 240) * 0.4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(
                  widget.result.name,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Dãy ban đầu",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.result.beforeSort.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),

            SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Dãy sau khi sắp xếp",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.result.afterSort.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),

            SizedBox(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Thời gian thực thi: ",
                          style: TextStyle(
                            fontSize: 17
                          ),
                        ),
                        Text(
                          widget.result.time.toString() + " micro giây",
                          style: TextStyle(
                              fontSize: 17
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                    Row(
                      children: [
                        Text(
                          "Bộ nhớ sử dụng: ",
                          style: TextStyle(
                              fontSize: 17
                          ),
                        ),
                        Text(
                          widget.result.memory.toString() + " bytes",
                          style: TextStyle(
                              fontSize: 17
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

}