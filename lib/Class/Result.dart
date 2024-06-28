import 'dart:ffi';

class Result {
  List<int> _beforeSort;
  List<int> _afterSort;
  double _time;
  double _memory;
  String _name;


  Result(
      this._beforeSort, this._afterSort, this._time, this._memory, this._name);

  List<int> get afterSort => List<int>.from(_afterSort);

  set afterSort(List<int> value) {
    _afterSort = List<int>.from(value);
  }

  List<int> get beforeSort => List<int>.from(_beforeSort);

  set beforeSort(List<int> value) {
    _beforeSort = List<int>.from(value);
    afterSort = _beforeSort;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  double get memory => _memory;

  set memory(double value) {
    _memory = value;
  }

  double get time => _time;

  set time(double value) {
    _time = value;
  }
}
