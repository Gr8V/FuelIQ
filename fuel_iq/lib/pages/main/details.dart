import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/home_page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {
  int _selectedDayIndex = 0;

  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // default to today
      firstDate: DateTime(2000), // earliest date allowed
      lastDate: DateTime(2100),  // latest date allowed
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Details",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            height: 1.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
    ),
      //body
    body: Padding(
      padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed:() {
                  _pickDate();
                },
                child: Text(
                  selectedDate != null
                      ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                      : todaysDate,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            Divider(height: 1, color: colorScheme.onSurface),
            Expanded(
              child: _pages[_selectedDayIndex],
            )
          ],
        ),
      ),
    );
  }
}


 // Dummy pages for each day
  final List<Widget> _pages = List.generate(
      30,
      (index) => Center(
            child: DailyData(index: index,),
          ));


class DailyData extends StatefulWidget {
  final int index;


  const DailyData({super.key, required this.index});
  
  @override
  State<DailyData> createState() => _DailyDataState();
}

class _DailyDataState extends State<DailyData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Day ${widget.index+1}"),
    );
  }
}