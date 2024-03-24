import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../utilities/unit_converter.dart';

class RecordActivityView extends StatefulWidget {
  final FirebaseAuth auth;
  const RecordActivityView({super.key, required this.auth});

  @override
  _RecordActivityViewState createState() => _RecordActivityViewState();
}

class _RecordActivityViewState extends State<RecordActivityView> {

  @override
  Widget build(BuildContext context) {
    final recordingProvider = Provider.of<RecordingViewModel>(context);
    FirebaseAuth auth = widget.auth;

    if (auth.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Record Activity'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You must be signed in to use this feature'),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Record Activity'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  recordingProvider.isRecording ? (recordingProvider
                      .isPaused
                      ? 'Paused'
                      : 'Recording...') : 'Not Recording',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Toggle recording status
                    if (!recordingProvider.isRecording) {
                      if (!recordingProvider.permissionGranted) {
                        await recordingProvider.requestPermission();
                      }

                      if (recordingProvider.permissionGranted) {
                        const LocationSettings locationSettings = LocationSettings(
                          accuracy: LocationAccuracy.best,
                          distanceFilter: 0, // number of meters the user must move to update location
                        );
                        recordingProvider.startRecording(locationSettings);
                      }
                    } else {
                      // pause/resume recording as it is already recording
                      recordingProvider.togglePause();
                    }
                    setState(() {

                    });
                  },
                  child: Text(
                    recordingProvider.isRecording
                        ? (recordingProvider
                        .isPaused ? 'Resume' : 'Pause')
                        : 'Start Recording',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Stop recording
                    setState(() {
                      recordingProvider.stopRecording();
                    });

                    // Show save or discard prompt
                    _showSaveDiscardPrompt(recordingProvider);
                  },
                  child: const Text('Stop Recording'),
                ),
                Expanded(
                    child: Consumer<RecordingViewModel>(
                        builder: (context, recordingProvider, _) {
                          return GridView.count(
                            primary: false,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Duration \n\n ${formatDuration(recordingProvider.record
                                      .duration)}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Number of Runs \n\n ${recordingProvider
                                      .record
                                      .numberOfRuns}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Total Distance \n\n ${convertMetersToMiles(recordingProvider
                                      .record
                                      .totalDistance)} miles",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Total Descent \n\n ${convertMetersToFeet(recordingProvider.record
                                      .totalVertical)} ft",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Max speed \n\n ${convertMetersPerSecondToMilesPerHour(recordingProvider.record
                                      .maxSpeed)} mph",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: Text(
                                  "Average Speed \n\n ${convertMetersPerSecondToMilesPerHour(recordingProvider.record
                                      .averageSpeed)} mph",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        })
                )
              ],
            ),
          )
      );
    }
  }



//Function to show the save or discard prompt
  void _showSaveDiscardPrompt(RecordingViewModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Recording?'),
          content: const Text('Do you want to save or discard the recording?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle discard action
                Navigator.pop(context);
                model.discardRecording();
                _showConfirmation('Recording Discarded!');
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                // Handle save action
                Navigator.pop(context);
                model.saveRecording();
                // _saveRecordingData();
                // _navigateToHistoryPage();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to show the confirmation message
  void _showConfirmation(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Handling OK action and navigate to another page
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

/*
Improved spacing and alignment in the UI to make it more visually appealing.
Simplified the logic of the _showSaveDiscardPrompt function by passing the
BuildContext directly instead of accessing it through context.
 */
