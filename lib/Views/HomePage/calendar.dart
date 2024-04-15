import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medireminder/Models/med_event.dart';
import 'package:medireminder/Services/s_database.dart';
import 'package:medireminder/View%20Models/vm_event.dart';
import 'package:medireminder/Widget/event_card.dart';
import 'package:medireminder/service_locator.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  final f = DateFormat('dd/MM');
  final vmEvent = serviceLocator.get<VMEvent>();
  Map<DateTime, List<MedEvent>> _eventList = {};
  Map<String, int> colormap = {};
  late ValueNotifier<List<MedEvent>> _selectedList;
  late Future _future;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _future = loadEvent();
    _selectedDay = _focusedDay;
    _selectedList = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadEvent() async {
    final eventList = await vmEvent.getEvents();
    setState(() {
      _eventList = eventList;
      _selectedList = ValueNotifier(_getEventsForDay(_selectedDay!));
    });
    colormap = colormapping();
  }

  List<MedEvent> _getEventsForDay(DateTime day) {
    List<MedEvent> list = [];
    for (var key in _eventList.keys) {
      if (isSameDay(key, day)) {
        list.addAll(_eventList[key]!);
      }
    }
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedList.value = _getEventsForDay(_selectedDay!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  focusedDay: _focusedDay,
                  eventLoader: _getEventsForDay,
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  calendarBuilders: _calenderBuilder(),
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Text(
                        'Schedule for ${f.format(_focusedDay)} :',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: IconButton(
                            onPressed: () async {
                              await SDataBase.instance
                                  .deleteSchedule('eurotapp');
                              await loadEvent();
                            },
                            icon: const Icon(Icons.refresh))),
                  ],
                ),
                SizedBox(
                  height: 350,
                  child: ValueListenableBuilder(
                      valueListenable: _selectedList,
                      builder: (context, value, _) {
                        return ListView.builder(
                            itemCount: value.length,
                            itemBuilder: ((context, index) {
                              return EventCard(
                                event: value[index],
                                color: Colors
                                    .primaries[colormap[value[index].title]!],
                              );
                            }));
                      }),
                ),
              ],
            ),
          );
        });
  }

  CalendarBuilders _calenderBuilder() {
    return CalendarBuilders(markerBuilder: (context, day, events) {
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final items = events[index] as MedEvent;
          return Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(1),
            child: Container(
              height: 7,
              width: 5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colormap.containsKey(items.title)
                      ? Colors.primaries[colormap[items.title]!]
                      : Colors.grey),
            ),
          );
        },
      );
    });
  }

  Map<String, int> colormapping() {
    Map<String, int> map = {};
    int index = 1;
    for (var lists in _eventList.values) {
      for (var event in lists) {
        if (!map.containsKey(event.title)) {
          map[event.title] = index;
          index++;
        }
      }
    }
    return map;
  }
}
