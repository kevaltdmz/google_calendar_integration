// ignore_for_file: implementation_imports, depend_on_referenced_packages, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:google_calendar/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/src/client.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime? startDate;
  late DateTime? endDate;
  final TextEditingController eventNameController = TextEditingController();

  final List<String> scope = [CalendarApi.calendarScope];
  final String credentials =
      '889303396455-dk3hpegiqs76qsltkpah3j21sbepf6q0.apps.googleusercontent.com';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${widget.user.displayName}'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                dateTimePickerWidget(
                  context: context,
                  fromStartDate: true,
                );
              },
              child: const Text(
                'Select start date',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                dateTimePickerWidget(
                  context: context,
                  fromStartDate: false,
                );
              },
              child: const Text(
                'Select end date',
              ),
            ),
            TextField(
              controller: eventNameController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // created new event
                Event event = Event();
                // setting the summary
                event.summary = eventNameController.text;
                // setting start date
                EventDateTime start = EventDateTime();
                start.dateTime = startDate;
                start.timeZone = 'GMT+05:30';
                event.start = start;
                // setting end date
                EventDateTime end = EventDateTime();
                end.dateTime = endDate;
                end.timeZone = 'GMT+05:30';
                event.end = end;

                // setting up attendees
                EventAttendee eventAttendee1 =
                    EventAttendee(email: 'dhruvinkansagra5@gmail.com');
                event.attendees = [eventAttendee1];

                var created = await createEventRequested(
                  event: event,
                  scopes: scope,
                );
                if (created) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Event added to the calender successfully :)',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Create Event'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await GoogleSignIn().signOut();
                } catch (e) {}
              },
              child: const Text(
                'Sign Out',
              ),
            ),
          ],
        ),
      ),
    );
  }

  dateTimePickerWidget({
    required BuildContext context,
    required bool fromStartDate,
  }) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        if (fromStartDate) {
          setState(() {
            startDate = dateTime;
          });
          startDate = add5Hours30Minutes(dateTime: startDate!);
        } else {
          setState(() {
            endDate = dateTime;
          });
          endDate = add5Hours30Minutes(dateTime: endDate!);
        }
      },
    );
  }

  DateTime add5Hours30Minutes({required DateTime dateTime}) {
    return dateTime.add(const Duration(hours: 5, minutes: 30));
  }
}

Future<bool> createEventRequested({
  required Event event,
  required List<String> scopes,
}) async {
  try {
    Client baseClient = Client();
    final token = accessToken;
    final expiry = DateTime.now()
        .add(const Duration(days: 1, hours: 5, minutes: 30))
        .toUtc();

    AccessToken accessTokenn = AccessToken('Bearer', token, expiry);

    AccessCredentials credentials = AccessCredentials(accessTokenn, '', scopes);
    var calendar = CalendarApi(authenticatedClient(baseClient, credentials));
    String calendarId = 'primary';
    ConferenceData conferenceData = ConferenceData();
    CreateConferenceRequest conferenceRequest = CreateConferenceRequest();

    // A unique ID should be used for every separate video conference event
    conferenceRequest.requestId = const Uuid().v4();
    conferenceData.createRequest = conferenceRequest;

    event.conferenceData = conferenceData;
    final eventData = event;
    debugPrint(eventData.toString());

    final Event event1 = await calendar.events.insert(event, calendarId,
        conferenceDataVersion: 1, sendUpdates: 'all');
    debugPrint('------------------${event1.start?.dateTime?.isUtc}');

    return false;
  } catch (e) {
    debugPrint(
        'Something went wrong while creating the google event ------- ${e.toString()}');
    return false;
  }
}
