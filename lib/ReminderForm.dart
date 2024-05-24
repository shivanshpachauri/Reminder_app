import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class ReminderForm extends StatefulWidget {
   const ReminderForm({super.key});
  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  String? _selectedDay;
  TimeOfDay? _selectedTime;
  String? _selectedActivity;

  final List<String> days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  final List<String> activities = [
    'Wake up', 'Go to gym', 'Breakfast', 'Meetings', 'Lunch',
    'Quick nap', 'Go to library', 'Dinner', 'Go to sleep'
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Select Day'),
            value: _selectedDay,
            items: days.map((String day) {
              return DropdownMenuItem<String>(
                value: day,
                child: Text(day),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDay = newValue;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: () => _selectTime(context),
            child: Text(
              _selectedTime == null
                  ? 'Select Time'
                  : _selectedTime!.format(context),
            ),
          ),
          const SizedBox(height: 16.0),
          DropdownButton<String>(
            hint: const Text('Select Activity'),
            value: _selectedActivity,
            items: activities.map((String activity) {
              return DropdownMenuItem<String>(
                value: activity,
                child: Text(activity),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedActivity = newValue;
              });
            },
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: _selectedDay == null ||
                _selectedTime == null ||
                _selectedActivity == null
                ? null
                : () {
              Provider.of<ReminderProvider>(context, listen: false).addReminder(
                Reminder(
                  day: _selectedDay!,
                  time: _selectedTime!,
                  activity: _selectedActivity!,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminder Added')),
              );
            },
            child: const Text('Add Reminder'),
          ),
        ],
      ),
    );
  }
}

class Reminder {
  final String day;
  final TimeOfDay time;
  final String activity;

  Reminder({required this.day, required this.time, required this.activity});
}

class ReminderProvider extends ChangeNotifier {
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    scheduleReminder(reminder);
    notifyListeners();
  }

  void scheduleReminder(Reminder reminder) {
    // Scheduling logic goes here
  }
}
