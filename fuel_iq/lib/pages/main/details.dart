import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {
  int _selectedDayIndex = 0;
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
        padding: const EdgeInsets.all(0), // remove extra padding if you want full width
        child: Column(
          children: [
            Row(
              children: List.generate(7, (index) {
                final isSelected = index == _selectedDayIndex;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    splashColor: Colors.transparent, // optional: remove ripple effect
                    highlightColor: Colors.transparent, // optional: remove highlight
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surface,
                            border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurface),
                          ),
                      child: Column(
                        
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.date_range),
                          Text('Day ${index + 1}'),
                        ],
                      ),
                    ),
                  ),
                );
              }),
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
      7,
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