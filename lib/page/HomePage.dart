import 'dart:io';
import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:sort_fu/Class/Result.dart';
import 'package:sort_fu/Class/Sort.dart';
import 'package:sort_fu/Widget/MultiSort.dart';
import 'package:sort_fu/Widget/SingleSort.dart';

import '../Class/process_memory.dart';

final List<Result> listResult = [];

typedef GetCurrentProcessNative = Pointer<Void> Function();
typedef GetCurrentProcessDart = Pointer<Void> Function();

typedef GetProcessMemoryInfoNative = Int8 Function(
    Pointer<Void> hProcess, Pointer<PROCESS_MEMORY_COUNTERS> ppsmemCounters, Int32 cb);
typedef GetProcessMemoryInfoDart = int Function(
    Pointer<Void> hProcess, Pointer<PROCESS_MEMORY_COUNTERS> ppsmemCounters, int cb);

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Sort_Nhonn sort_nhonn = new Sort_Nhonn();
  int _numberSort = 0;
  Map<int, Function> sortMap = {
    0: () => Sort_Nhonn().Bubble_Sort,
    1: () => Sort_Nhonn().Selection_Sort,
    2: () => Sort_Nhonn().Insertion_Sort,
    3: () => Sort_Nhonn().Cocktail_Shaker_Sort,
    4: () => Sort_Nhonn().Gnome_Sort,

    5: () => Sort_Nhonn().Merge_Sort,
    6: () => Sort_Nhonn().Heap_Sort,
    7: () => Sort_Nhonn().Quick_Sort,
    8: () => Sort_Nhonn().TimSort,
    9: () => Sort_Nhonn().introSort,

    10: () => Sort_Nhonn().radixSort,
    11: () => Sort_Nhonn().countSort,
    12: () => Sort_Nhonn().bucketSort,
    13: () => Sort_Nhonn().shellSort,
    14: () => Sort_Nhonn().Pigeonhole_Sort,
    15: () => Sort_Nhonn().Flash_Sort,
  };

  List<String> _types = ['O(n^2)', 'O(n log n)', 'O(n)'];
  List<String?> selectedType = [];

  List<String?> selectedItem = [];
  List<String> _items1 = ['Bubble Sort', 'Selection Sort', 'Insertion Sort', 'Cocktail Shaker Sort', 'Gnome Sort'];
  List<String> _items2 = ['Merge Sort', 'Heap Sort', 'Quick Sort', 'Tim Sort', 'Intro Sort'];
  List<String> _items3 = ['Radix Sort', 'Counting Sort', 'Bucket Sort', 'Shell Sort', 'Pigeonhole Sort', 'Flash Sort'];

  // Controller
  TextEditingController _listNumber = TextEditingController();
  TextEditingController _minNumber = TextEditingController();
  TextEditingController _maxNumber = TextEditingController();
  TextEditingController _countNumber = TextEditingController();
  TextEditingController _lootCount = TextEditingController();

  int SortPointer(String type, String items) {
    int typeIndex = _types.indexOf(type);
    if (typeIndex == -1) return -1;

    int itemIndex = -1;

    switch (typeIndex) {
      case 0: // O(n^2)
        itemIndex = _items1.indexOf(items);
        break;
      case 1:
        itemIndex = _items2.indexOf(items);
        break;
      case 2:
        itemIndex = _items3.indexOf(items);
        break;
    }

    if (itemIndex == -1) return -1;

    int sortIndex = 0;
    switch (typeIndex) {
      case 0:
        sortIndex = itemIndex;
        break;
      case 1:
        sortIndex = itemIndex + _items1.length;
        break;
      case 2:
        sortIndex = itemIndex + _items1.length + _items2.length;
        break;
    }

    return sortIndex;
  }

  void _increaseSort(){
    selectedItem.add(null);
    selectedType.add(null);
    _numberSort += 1;
  }
  void _reduceSort(){
    if(_numberSort == 0) return;
    selectedItem.removeAt(selectedItem.length - 1);
    selectedType.removeAt(selectedType.length - 1);
    _numberSort -= 1;
  }
  void _generateListNumber(){
    if(_minNumber.text == '' || _maxNumber.text == '' || _countNumber.text == '') return;

    List<int> dmpList = [];
    Random random = Random();
    int min = int.parse(_minNumber.text);
    int max = int.parse(_maxNumber.text);

    for (int i = 0; i < int.parse(_countNumber.text); i++) {
      int randomNumber = min + random.nextInt(max - min + 1);
      dmpList.add(randomNumber);
    }

    String dmpText = dmpList.toString();
    dmpText = dmpText.substring(1, dmpText.length - 1);
    _listNumber.text = dmpText;
  }

  List<int> _processInput() {
    List<int> numbers = [];

    String input = _listNumber.text;
    List<String> stringNumbers = input.split(',');
    numbers = stringNumbers.map((str) => int.tryParse(str.trim()) ?? 0).toList();

    return numbers;
  }

  List<double> _measureSort(void Function(List<int>, int, int) sortFunction, List<int> list, int start, int end) {
    int repetitions = 1;
    if (_lootCount.text != '') repetitions = int.parse(_lootCount.text);

    int totalElapsedMicroseconds = 0;
    int totalMemoryUsed = 0;

    // Load necessary libraries
    final kernel32 = DynamicLibrary.open('kernel32.dll');
    final psapi = DynamicLibrary.open('psapi.dll');
    final getCurrentProcess = kernel32.lookupFunction<GetCurrentProcessNative, GetCurrentProcessNative>('GetCurrentProcess');
    final getProcessMemoryInfo = psapi.lookupFunction<GetProcessMemoryInfoNative, GetProcessMemoryInfoDart>('GetProcessMemoryInfo');
    final process = getCurrentProcess();

    // Allocate memory for PROCESS_MEMORY_COUNTERS
    final counters = calloc<PROCESS_MEMORY_COUNTERS>();
    counters.ref.cb = sizeOf<PROCESS_MEMORY_COUNTERS>();

    // Measure sorting performance
    Stopwatch stopwatch = Stopwatch();
    for (int i = 0; i < repetitions; i++) {
      List<int> tempList = List.from(list);

      // Measure memory before sorting
      getProcessMemoryInfo(process, counters, sizeOf<PROCESS_MEMORY_COUNTERS>());
      int initialMemoryUsed = counters.ref.WorkingSetSize;

      // Measure time taken for sorting
      stopwatch.reset();
      stopwatch.start();
      sortFunction(tempList, start, end);
      stopwatch.stop();
      totalElapsedMicroseconds += stopwatch.elapsedMicroseconds;

      // Measure memory after sorting
      getProcessMemoryInfo(process, counters, sizeOf<PROCESS_MEMORY_COUNTERS>());
      int finalMemoryUsed = counters.ref.WorkingSetSize;
      totalMemoryUsed += (finalMemoryUsed - initialMemoryUsed);
    }

    // Free allocated memory
    calloc.free(counters);

    // Calculate averages
    double averageElapsedMicroseconds = totalElapsedMicroseconds / repetitions;
    double averageMemoryUsed = totalMemoryUsed / repetitions;

    return [averageElapsedMicroseconds, averageMemoryUsed];
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // MAIN SCENE
          Container(
            //color: Colors.blue,
            width: MediaQuery.of(context).size.width * 0.73,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: listResult.length != 0 ? MultiSort() : Container(),
            ),
          ),

          // MENU BAR
          Container(
            //color: Colors.red,
            width: MediaQuery.of(context).size.width * 0.27,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 0, right: 20, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Container(
                      //color: Colors.red,
                      height: (MediaQuery.of(context).size.height - 40) * 0.8,

                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: (){

                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(35.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 1.8,
                                                blurRadius: 1,
                                                offset: Offset(1, 2),
                                              ),
                                            ],
                                          ),

                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                            child: Text(
                                                "Nhập file"
                                            ),
                                          )
                                      )
                                  ),

                                  SizedBox(
                                    width: 20,
                                  ),

                                  InkWell(
                                      onTap: (){

                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(35.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 1.8,
                                                blurRadius: 1,
                                                offset: Offset(1, 2),
                                              ),
                                            ],
                                          ),

                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                            child: Text(
                                                "Xuất file"
                                            ),
                                          )
                                      )
                                  ),
                                ],
                              ),

                              // DANH SÁCH SỐ
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10, top: 20),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Danh sách số",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            Text(
                                              " (Phân chia bởi dấu phẩy)",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
                                          controller: _listNumber,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Nhập số',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // OPTIONS TAO DANH SACH
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.123,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: TextField(
                                              controller: _minNumber,
                                              //maxLines: null,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Min',
                                              ),
                                            ),
                                          ),
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.123,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: TextField(
                                              controller: _maxNumber,
                                              //maxLines: null,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Max',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
                                          controller: _countNumber,
                                          //maxLines: null,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Số lượng',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),

                              Container(
                                //color: Colors.blue,
                                //height: 20,
                                child: InkWell(
                                  onTap: (){
                                    _generateListNumber();
                                    setState(() {});

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFEFEFF),
                                      borderRadius: BorderRadius.circular(35.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2.5,
                                          blurRadius: 1,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
                                      child: Text(
                                        "Tạo",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20,),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                color: Colors.grey,
                                child: SizedBox(height: 1,),
                              ),
                              SizedBox(height: 20,),

                              // SORT SETTINGS
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: TextField(
                                        controller: _lootCount,
                                        //maxLines: null,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Số lượng lặp',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Số lượng Sort: ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      SizedBox(width: 10,),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                _reduceSort();
                                                setState(() {

                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight: Radius.circular(0),
                                                    bottomLeft: Radius.circular(5),
                                                    bottomRight: Radius.circular(0),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 12.5, right: 12.5),
                                                  child: Text(
                                                    "-",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border( 
                                                  top: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                                child: Text(
                                                  _numberSort.toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),

                                            InkWell(
                                              onTap: (){
                                                _increaseSort();
                                                setState(() {

                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(0),
                                                    topRight: Radius.circular(5),
                                                    bottomLeft: Radius.circular(0),
                                                    bottomRight: Radius.circular(5),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                                  child: Text(
                                                    "+",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      for (int i = 0; i < _numberSort; i++)
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.1,
                                                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),

                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      value: selectedType[i],
                                                      hint: Container(
                                                        width: MediaQuery.of(context).size.width * 0.05,
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Text(
                                                            'Loại Sort',
                                                            style: TextStyle(
                                                                fontSize: 12
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      onChanged: (String? newValue) {
                                                        setState(() {
                                                          selectedType[i] = newValue;
                                                          selectedItem[i] = null;
                                                        });
                                                      },
                                                      items: _types.map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width * 0.05,
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(
                                                                value,
                                                                style: TextStyle(
                                                                    fontSize: 12
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: 10,),

                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.105,
                                                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(color: Colors.grey, width: 1.0),
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: selectedType[i] == null
                                                      ? Container()
                                                      : DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      value: selectedItem[i],
                                                      hint: Container(
                                                        width: MediaQuery.of(context).size.width * 0.05,
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Text(
                                                            'Chọn Sort',
                                                            style: TextStyle(
                                                                fontSize: 12
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      onChanged: (String? newValue) {
                                                        setState(() {
                                                          selectedItem[i] = newValue;
                                                        });
                                                      },
                                                      items: (selectedType[i] == 'O(n^2)'
                                                          ? _items1
                                                          : (selectedType[i] == 'O(n log n)' ? _items2 : _items3))
                                                          .map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width * 0.05,
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Text(
                                                                value,
                                                                style: TextStyle(
                                                                    fontSize: 12
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 10,)
                                          ],
                                        ),

                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),


                    Container(
                      //color: Colors.yellow,
                      height: (MediaQuery.of(context).size.height - 40) * 0.2,
                      child: Center(
                        child: InkWell(
                            onTap: (){
                              listResult.clear();
                              for(int i = 0; i < _numberSort; i++) {
                                if(selectedItem[i] == null || selectedType[i] == null) continue;
                                Result dmpResult = new Result([], [], 0, 0, selectedItem[i].toString());
                                int type_of_sort = SortPointer(selectedType[i].toString(), selectedItem[i].toString());
                                //print(type_of_sort);

                                dmpResult.beforeSort = _processInput();
                                List <double> dmpListNum = _measureSort(sortMap[type_of_sort]!(), _processInput(), 0,  _processInput().length - 1);
                                dmpResult.time = dmpListNum[0];
                                dmpResult.memory = dmpListNum[1];
                                List<int> dmpAfter = _processInput();
                                sortMap[type_of_sort]!()(dmpAfter, 0, _processInput().length - 1);

                                dmpResult.afterSort = dmpAfter;
                                listResult.add(dmpResult);
                              }

                              setState(() {
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEFEFF),
                                  borderRadius: BorderRadius.circular(35.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: Offset(1, 2),
                                    ),
                                  ],
                                ),

                                child: Padding(
                                  padding: EdgeInsets.only(top: 7, bottom: 7, left: 45, right: 45),
                                  child: Text(
                                    "Xắp xếp",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}