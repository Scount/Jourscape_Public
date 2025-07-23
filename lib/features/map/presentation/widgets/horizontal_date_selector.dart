import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jourscape/core/design/shadow.dart';

class HorizontalDateSelector extends StatefulWidget {
  final double height;
  final ValueChanged<DateTime>? onDateChanged;

  const HorizontalDateSelector({
    super.key,
    this.height = 75.0,
    this.onDateChanged,
  });

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  late PageController _pageController;
  late DateTime _currentCenteredDate;

  final int _initialVirtualPage = 2000000000;
  late DateTime _initialReferenceDateForVirtualPage;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initialReferenceDateForVirtualPage = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    _pageController = PageController(
      initialPage: _initialVirtualPage,
      viewportFraction: 0.35,
    );

    _currentCenteredDate = _getDateForPageIndex(_initialVirtualPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateChanged?.call(_currentCenteredDate);
    });

    // Listener to update _currentCenteredDate as the PageView scrolls
    _pageController.addListener(() {
      if (_pageController.page != null) {
        final int newPageIndex = _pageController.page!.round();

        final DateTime newCenteredDate = _getDateForPageIndex(newPageIndex);

        if (!DateUtils.isSameDay(_currentCenteredDate, newCenteredDate)) {
          setState(() {
            _currentCenteredDate = newCenteredDate;
          });
          widget.onDateChanged?.call(_currentCenteredDate);
        }
      }
    });
  }

  DateTime _getDateForPageIndex(int pageIndex) {
    final int daysDelta = pageIndex - _initialVirtualPage;
    return _initialReferenceDateForVirtualPage.add(Duration(days: daysDelta));
  }

  void _selectDateFromPicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentCenteredDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select a Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue.shade700,
            colorScheme: ColorScheme.light(primary: Colors.blue.shade700),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null &&
        !DateUtils.isSameDay(pickedDate, _currentCenteredDate)) {
      final Duration daysDifference = pickedDate.difference(
        _initialReferenceDateForVirtualPage,
      );
      final int targetPageIndex = _initialVirtualPage + daysDifference.inDays;

      _pageController.jumpToPage(targetPageIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,

        itemBuilder: (context, index) {
          final DateTime date = _getDateForPageIndex(index);
          final bool isCentered = DateUtils.isSameDay(
            date,
            _currentCenteredDate,
          );

          return GestureDetector(
            onTap: isCentered ? () => _selectDateFromPicker(context) : null,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: isCentered ? 0 : 5),
                decoration: BoxDecoration(
                  color: const Color(0xffe8fcf3),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  boxShadow: shadow,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(date),
                      style: TextStyle(
                        color: isCentered ? Colors.red : Colors.blue.shade800,
                        fontSize: isCentered ? 16 : 14,
                        fontWeight: isCentered
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy').format(date),
                      style: TextStyle(
                        color: isCentered ? Colors.red : Colors.blue.shade800,
                        fontSize: isCentered ? 16 : 14,
                        fontWeight: isCentered
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
