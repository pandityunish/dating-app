import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:intl/intl.dart';

import '../chat/colors.dart';
import '../global_vars.dart';
class Calender extends StatefulWidget {
  const Calender({
    Key? key,
    required this.useTwentyOneYears,
    required this.setdate,
  }) : super(key: key);

  final Function setdate;
  final bool useTwentyOneYears;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  int? _selectedDay;
  String? _selectedMonth;
  int? _selectedYear;
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
    // Initialize with null to show placeholder texts
    _selectedDay = null;
    _selectedMonth = null;
    _selectedYear = null;

    // Generate years list based on useTwentyOneYears
    final startYear =
        widget.useTwentyOneYears ? _todayYear - 21 : _todayYear - 18;
    _years = List.generate(
      widget.useTwentyOneYears ? 50 : 53,
      (index) => startYear - index,
    ).reversed.toList();
  }

  void _updateDaysInMonth() {
    setState(() {
      // Only update February's days if month and year are selected
      if (_selectedMonth == 'February' && _selectedYear != null) {
        // Correct leap year calculation
        bool isLeapYear = (_selectedYear! % 4 == 0 &&
                _selectedYear! % 100 != 0) ||
            (_selectedYear! % 400 == 0);
        _daysInMonth['February'] = isLeapYear ? 29 : 28;
      } else {
        _daysInMonth['February'] = 28; // Reset February if not selected
      }

      // Ensure _selectedDay is valid for the current month
      if (_selectedMonth != null && _selectedDay != null) {
        final maxDays = _daysInMonth[_selectedMonth] ?? 31;
        if (_selectedDay! > maxDays) {
          _selectedDay = maxDays;
        }
      }
    });

    // Call setdate only if all values are selected
    if (_selectedDay != null &&
        _selectedMonth != null &&
        _selectedYear != null) {
      final monthIndex =
          _monthNames.indexWhere((element) => element == _selectedMonth) + 1;
      final birthday = DateTime(_selectedYear!, monthIndex, _selectedDay!);
      final duration = AgeCalculator.age(birthday);

      if (duration.years == 70) {
        widget.setdate(
          DateTime.now().day,
          DateTime.now().month,
          _selectedYear,
        );
      } else {
        widget.setdate(_selectedDay, monthIndex, _selectedYear);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Date Dropdown
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width * 0.29,
              child: Center(
                child: DropdownButton<int>(
                  underline: Container(),
                  value: _selectedDay,
                  hint:  Text(
                    "Day",
                    style: TextStyle(color: newtextColor),
                  ),
                  iconEnabledColor: newtextColor,
                  items: List.generate(
                    _daysInMonth[_selectedMonth] ?? _daysInMonth['January']!,
                    (index) => index + 1,
                  ).map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        value < 10 ? '0$value' : '$value',
                        style:  TextStyle(color: newtextColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDay = newValue!;
                      _updateDaysInMonth();
                    });
                  },
                ),
              ),
            ),
          ),
          // Month Dropdown
          Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width * 0.29,
              child: Center(
                child: DropdownButton<String>(
                  alignment: AlignmentDirectional.center,
                  underline: Container(),
                  value: _selectedMonth,
                  hint:  Text(
                    "Month",
                    style: TextStyle(color: newtextColor),
                  ),
                  iconEnabledColor: newtextColor,
                  items: _monthNames.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style:  TextStyle(color: newtextColor),
                      ),
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
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width * 0.29,
              child: Center(
                child: DropdownButton<int>(
                  underline: Container(),
                  value: _selectedYear,
                  hint:  Text(
                    "Year",
                    style: TextStyle(color: newtextColor),
                  ),
                  iconEnabledColor: newtextColor,
                  items: _years.map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        '$value',
                        style:  TextStyle(color: newtextColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedYear = newValue!;
                      _updateDaysInMonth();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}