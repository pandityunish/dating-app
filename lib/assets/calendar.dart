import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:intl/intl.dart';

import '../chat/colors.dart';
import '../global_vars.dart';

class Calender extends StatefulWidget {
  Calender({Key? key, required this.useTwentyOneYears, required this.setdate})
      : super(key: key);

  // final String title;
  Function setdate;
  bool useTwentyOneYears;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  int? _selectedDay;
  String? _selectedMonth;
  int ?_selectedYear ;
  String ?_newselectedYear ;
  final int _todayYear = DateTime.now().year;

  final Map<String, int> _daysInMonth = {
    'January': 31,
    'February': 28,
    'March': 31,
    'April': 30,
    'May': 31,
    'June': 30,
    'July': 31,
    'August': 31,
    'September': 30,
    'October': 31,
    'November': 30,
    'December': 31,
  };

  late List<int> _years;

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    final startYear =
        widget.useTwentyOneYears ? _todayYear - 21 : _todayYear - 18;
    setState(() {
      _selectedYear = startYear;
    });
    _years = List.generate(
            widget.useTwentyOneYears ? 50 : 53, (index) => startYear - index)
        .reversed
        .toList();
    // setlist(widget.useTwentyOneYears);
  }

  setlist() {
    print("function run again");
    final startYear =
        widget.useTwentyOneYears ? _todayYear - 21 : _todayYear - 18;
    if (widget.useTwentyOneYears) {
      if (_selectedYear! > startYear) {
        setState(() {
          _selectedYear = startYear;
        });
      }
    }

    _years = List.generate(
            widget.useTwentyOneYears ? 50 : 53, (index) => startYear - index)
        .reversed
        .toList();
  }

@override
Widget build(BuildContext context) {
  if (widget.useTwentyOneYears) {
    setlist();
  } else {
    setlist();
  }

  // Convert years to strings for the dropdown
  List<String> _yearsWithText = _years.map((year) => '$year').toList();
_yearsWithText.add("Year");
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Date Dropdown
        Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          child: SizedBox(
            height: 46,
            width: MediaQuery.of(context).size.width * 0.29,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  underline: Container(
                    color: Colors.white,
                  ),
                  value: _selectedDay,
                  hint: Text(
                    "Date",
                    style: TextStyle(color: newtextColor),
                  ),
                  iconEnabledColor: newtextColor,
                  items: List.generate(
                      _daysInMonth[_selectedMonth ?? "January"] ?? 0,
                      (index) => index + 1).map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value < 10 ? '0$value' : '$value',
                          style: TextStyle(color: newtextColor)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                      _updateDaysInMonth();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        // Month Dropdown
        Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          child: SizedBox(
            height: 46,
            width: MediaQuery.of(context).size.width * 0.29,
            child: Center(
              child: DropdownButton<String>(
                alignment: AlignmentDirectional.center,
                underline: Container(
                  color: Colors.white,
                ),
                value: _selectedMonth,
                hint: Text(
                  "Month",
                  style: TextStyle(color: newtextColor),
                ),
                iconEnabledColor: newtextColor,
                items: _monthNames.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: newtextColor)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMonth = newValue!;
                    _updateDaysInMonth();
                  });
                },
              ),
            ),
          ),
        ),
        // Year Dropdown
        Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          child: SizedBox(
            height: 46,
            width: MediaQuery.of(context).size.width * 0.29,
            child: Row(
              children: [
                const SizedBox(width: 20),
                DropdownButton<String>(
                  underline: Container(
                    color: Colors.white,
                  ),
                  value: _newselectedYear != null ? '$_newselectedYear' : "Year",
                  hint: Text(
                    "Year",
                    style: TextStyle(color: newtextColor),
                  ),
                  iconEnabledColor: newtextColor,
                  items: _yearsWithText.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: newtextColor)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                     setState(() {
                        _newselectedYear=newValue;
                     });

                      _selectedYear = int.parse(newValue!);
                      _updateDaysInMonth();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  void _updateDaysInMonth() {
    // print(_selectedDay);
    // print(_selectedMonth);
    // print(_monthNames.indexWhere((element) => element == _selectedMonth) + 1);

    setState(() {
      if (_selectedMonth == 'February') {
        if (_selectedYear! % 4 == 0) {
          if (_selectedYear! % 50 == 0) {
            if (_selectedYear! % 400 == 0) {
              _daysInMonth[_selectedMonth!] = 29;
            } else {
              _daysInMonth[_selectedMonth!] = 28;
            }
          } else {
            _daysInMonth[_selectedMonth!] = 29;
          }
        } else {
          _daysInMonth[_selectedMonth!] = 28;
        }
      } else {
        _daysInMonth[_selectedMonth!] = _monthNames.contains(_selectedMonth)
            ? _daysInMonth[_selectedMonth]!
            : 31;
      }

      if (_daysInMonth[_selectedMonth]! < _selectedDay!) {
        _selectedDay = _daysInMonth[_selectedMonth]!;
      }
    });

    print(DateTime.now().month);

    DateDuration duration = DateDuration();
    DateTime birthday = DateTime(
        _selectedYear!,
        _monthNames.indexWhere((element) => element == _selectedMonth) + 1,
        _selectedDay!);
    duration = AgeCalculator.age(birthday);
    if (duration.years == 70) {
      widget.setdate(
        DateTime.now().day,
        DateTime.now().month,
        _selectedYear,
      );
    } else {
      widget.setdate(
        _selectedDay,
        _monthNames.indexWhere((element) => element == _selectedMonth) + 1,
        _selectedYear,
      );
    }
    final startYear =
        widget.useTwentyOneYears ? _todayYear - 21 : _todayYear - 18;
    _years = List.generate(
            widget.useTwentyOneYears ? 50 : 53, (index) => startYear - index)
        .reversed
        .toList();
  }
}
