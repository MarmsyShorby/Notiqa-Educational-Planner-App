import 'package:flutter/material.dart';
import 'calendar_events.dart';

class Scheduler extends StatefulWidget {
  const Scheduler({super.key});

  @override
  State<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends State<Scheduler> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  Map<DateTime, List<Event>> events = {};

  DateTime normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  int firstWeekdayOffset(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    return firstDay.weekday % 7; // Sunday-first
  }

  int daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }

  String monthConverter(int monthNum) {
    String monthName = "";
    switch (monthNum) {
      case 1:
        monthName = "January";
      case 2:
        monthName = "February";
      case 3:
        monthName = "March";
      case 4:
        monthName = "April";
      case 5:
        monthName = "May";
      case 6:
        monthName = "June";
      case 7:
        monthName = "July";
      case 8:
        monthName = "August";
      case 9:
        monthName = "September";
      case 10:
        monthName = "October";
      case 11:
        monthName = "November";
      case 12:
        monthName = "December";
        break;
      default:
        monthName = "MONTH_UNAVAILABLE";
    }

    return monthName;
  }

  void addEventDialog(DateTime date) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              events.putIfAbsent(date, () => []);
              events[date]!.add(
                Event(
                  title: titleController.text,
                  description: descController.text,
                ),
              );
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void editEvent(DateTime date, int index) {
    final event = events[date]![index];

    final titleController = TextEditingController(text: event.title);
    final descController = TextEditingController(text: event.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              event.title = titleController.text;
              event.description = descController.text;
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteEvent(DateTime date, int index) {
    events[date]!.removeAt(index);

    if (events[date]!.isEmpty) {
      events.remove(date);
    }

    setState(() {});
  }

  void prevMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      selectedDate = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      selectedDate = DateTime(
        currentMonth.year,
        currentMonth.month,
        currentMonth.day,
      );
    });
  }

  Widget buildCalendar() {
    final offset = firstWeekdayOffset(currentMonth);
    final totalDays = daysInMonth(currentMonth);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("Sun"),
            Text("Mon"),
            Text("Tue"),
            Text("Wed"),
            Text("Thu"),
            Text("Fri"),
            Text("Sat"),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            itemCount: offset + totalDays,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemBuilder: (context, index) {
              if (index < offset) {
                return const SizedBox();
              }

              final dayNumber = index - offset + 1;

              final date = DateTime(
                currentMonth.year,
                currentMonth.month,
                dayNumber,
              );

              final normalized = normalize(date);
              final hasEvents = events.containsKey(normalized);
              final isSelected = normalized == normalize(selectedDate);
              final DateTime today = normalize(DateTime.now());
              final isToday = normalized == today;
              final int eventDistance = normalized
                  .difference(today)
                  .inDays
                  .abs();
              const int eventDisClamp = 30;
              final double t =
                  (eventDistance.clamp(0, eventDisClamp) / eventDisClamp);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue
                        : isToday
                        ? Colors.purpleAccent
                        : null,
                    border: Border.all(
                      color: isToday ? Colors.deepPurpleAccent : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Text(dayNumber.toString())),
                      if (hasEvents)
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Color.lerp(Colors.red, Colors.green, t),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildEventPanel() {
    final normalized = normalize(selectedDate);
    final dayEvents = events[normalized] ?? [];

    return Column(
      children: [
        Text(
          "Events for ${monthConverter(currentMonth.month)} ${selectedDate.day}, ${currentMonth.year}:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: dayEvents.isEmpty
              ? const Center(child: Text("No Events"))
              : ListView.builder(
                  itemCount: dayEvents.length,
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];

                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => editEvent(normalized, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteEvent(normalized, index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        ElevatedButton(
          onPressed: () => addEventDialog(normalized),
          child: const Text("Add Event"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduler"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: prevMonth, icon: Icon(Icons.arrow_left)),
              Expanded(
                child: Center(
                  child: Text(
                    "${monthConverter(currentMonth.month)} ${currentMonth.year}",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              IconButton(onPressed: nextMonth, icon: Icon(Icons.arrow_right)),
            ],
          ),
          SizedBox(height: 10),
          Expanded(flex: 2, child: buildCalendar()),
          const Divider(),
          Expanded(flex: 1, child: buildEventPanel()),
        ],
      ),
    );
  }
}
